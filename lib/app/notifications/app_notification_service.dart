import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moniepoint_flutter/app/notifications/model/data/remote_notification_message.dart';
import 'package:moniepoint_flutter/app/notifications/model/workers/device_token_registration_worker.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/notification_handler.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/work/ios_background_task_worker.dart';
import 'package:workmanager/workmanager.dart';

FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();

class AppNotificationService {

  final AndroidInitializationSettings _androidInitSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
  final IOSInitializationSettings _iosInitializationSettings = IOSInitializationSettings();
  late final InitializationSettings _notificationInitializationSettings = InitializationSettings(
      android: _androidInitSettings,
      iOS: _iosInitializationSettings
  );

  static const FCM_TOKEN = "FCM_TOKEN";
  static const FCM_TOKEN_REGISTERED = "FCM_TOKEN_REGISTERED";

  AppNotificationService();

  void initialize() async {
    FirebaseMessaging.instance.onTokenRefresh.listen(onTokenRefresh);
    FirebaseMessaging.onMessage.listen(onMessageReceived);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      final dataMessage = _extractDataMessage(event) ?? {};
      final messageType = enumFromString<MessageType>(MessageType.values, dataMessage["messageType"] ?? "");
      final handler = NotificationHandler.getInstance(messageType, dataMessage);
      await handler.handle();
    });

    await _onAppLaunchWithNotification();
    await notificationPlugin.initialize(
        _notificationInitializationSettings,
        onSelectNotification: _onNotificationSelected
    );
    await _retrieveFirebaseToken();
  }

  Future<void> _onAppLaunchWithNotification() async {
    final notificationDetails = await notificationPlugin.getNotificationAppLaunchDetails();
    if(notificationDetails?.didNotificationLaunchApp ?? false) {
      final payload = notificationDetails?.payload;
      _onNotificationSelected(payload);
    }
  }

  void _onNotificationSelected(String? payload) async {
    try {
      final remoteMessage = jsonDecode(payload ?? "{}");
      final remoteMessageType = remoteMessage["messageType"];
      final messageType = enumFromString<MessageType>(MessageType.values, remoteMessageType ?? "");
      final handler = NotificationHandler.getInstance(messageType, remoteMessage);
      await handler.handle();
    } on FormatException {
      //Do nothing
    }
  }

  Future<void> _retrieveFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken().catchError((e) {
      print("Unable to fetch token at the moment");
      return null;
    });

    print("DeviceToken ==> $token");
    if(token != null && token.isNotEmpty) {
      final previousToken = PreferenceUtil.getValue(FCM_TOKEN);
      final isTokenRegistered = PreferenceUtil.getValue<bool>(FCM_TOKEN_REGISTERED);

      if(previousToken == token && isTokenRegistered == true) {
        print("Same Token, Unable to register");
        return;
      }

      PreferenceUtil.saveValue(FCM_TOKEN, token);
      _registerDeviceToken();
    }
  }

  void onTokenRefresh(String token) {
    PreferenceUtil.saveValue(FCM_TOKEN, token);
    PreferenceUtil.saveValue(FCM_TOKEN_REGISTERED, false);
    _registerDeviceToken(refresh: true);
  }

  void _registerDeviceToken({bool refresh = false}) {
    if(Platform.isAndroid) {
      Workmanager().registerOneOffTask(
        "DeviceTokenRegistrationWorker.WORKER_KEY",
        DeviceTokenRegistrationWorker.WORKER_KEY,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        backoffPolicy: BackoffPolicy.exponential,
        constraints: Constraints(networkType: NetworkType.connected),
      );
    } else if(Platform.isIOS) {
      Future.delayed(Duration(milliseconds: 5000), () {
        if(refresh) {
          IosBackgroundTaskWorker.addTaskToQueue(DeviceTokenRegistrationWorker.WORKER_KEY);
        } else {
          DeviceTokenRegistrationWorker().execute(null).then((value) {
            if (value == false) IosBackgroundTaskWorker.addTaskToQueue(DeviceTokenRegistrationWorker.WORKER_KEY);
          }).catchError((e) {
            IosBackgroundTaskWorker.addTaskToQueue(DeviceTokenRegistrationWorker.WORKER_KEY);
          });
        }
      });
    }
  }

  void onMessageReceived(RemoteMessage message) async {
    print("Foreground Message <===> ${message.data}");
    //if the user is not logged in then we should make it a background message
    if(UserInstance().getUser() == null) return onBackgroundMessageReceived(message);

    final dataMessage = _extractDataMessage(message) ?? {};
    final messageType = enumFromString<MessageType>(MessageType.values, dataMessage["messageType"] ?? "");
    final handler = NotificationHandler.getInstance(messageType, dataMessage);
    await handler.notify(NotificationHandler.FOREGROUND_MESSAGE);
  }
}

Map<String, dynamic>? _extractDataMessage(RemoteMessage message) {
  try {
    final dataMessage = message.data["dataMessage"];
    if(dataMessage == null || (dataMessage is String && dataMessage.isEmpty)) {
      return null;
    }

    if(dataMessage is Map<String, dynamic>?) return dataMessage;
    return jsonDecode(dataMessage);
  } catch(e) {
    print(e);
    return null;
  }
}

@visibleForTesting
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  print("Background Message ===> ${message.data}");
  final dataMessage = _extractDataMessage(message) ?? {};
  final messageType = enumFromString<MessageType>(MessageType.values, dataMessage["messageType"] ?? "");
  final handler = NotificationHandler.getInstance(messageType, dataMessage);
  await handler.notify(NotificationHandler.BACKGROUND_MESSAGE);
}