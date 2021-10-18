import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moniepoint_flutter/app/notifications/model/data/remote_notification_message.dart';
import 'package:moniepoint_flutter/app/notifications/model/device_token_registration_worker.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/notification_handler.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/work/ios_background_task_worker.dart';
import 'package:workmanager/workmanager.dart';
import 'package:collection/collection.dart';

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
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessageReceived);

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

    if(token != null && token.isNotEmpty) {
      final previousToken = PreferenceUtil.getValue(FCM_TOKEN);
      final isTokenRegistered = PreferenceUtil.getValue<bool>(FCM_TOKEN_REGISTERED);

      if(previousToken == token && isTokenRegistered == true) return;

      PreferenceUtil.saveValue(FCM_TOKEN, token);
      _registerDeviceToken();
    }
  }

  void onTokenRefresh(String token) {
    PreferenceUtil.saveValue(FCM_TOKEN, token);
    PreferenceUtil.saveValue(FCM_TOKEN_REGISTERED, false);
    _registerDeviceToken();
  }

  void _registerDeviceToken() {
    if(Platform.isAndroid) {
      Workmanager().registerOneOffTask(
          "DeviceTokenRegistrationWorker.WORKER_KEY",
          DeviceTokenRegistrationWorker.WORKER_KEY
      );
    } else if(Platform.isIOS) {
      IosBackgroundTaskWorker.addTaskToQueue(DeviceTokenRegistrationWorker.WORKER_KEY);
    }
  }

  void onMessageReceived(RemoteMessage message) async {
    print("Message Received ===> ${jsonEncode(message)}");
    print("Message Received ===> ${message.data}");
    final messageType = enumFromString<MessageType>(MessageType.values, message.messageType ?? "");
    final handler = NotificationHandler.getInstance(messageType, message.data);
    await handler.notify(NotificationHandler.FOREGROUND_MESSAGE);
  }
}

Future<void> _onBackgroundMessageReceived(RemoteMessage message) async {
    final messageType = enumFromString<MessageType>(MessageType.values, message.messageType ?? "");
    final handler = NotificationHandler.getInstance(messageType, message.data);
    await handler.notify(NotificationHandler.BACKGROUND_MESSAGE);
}