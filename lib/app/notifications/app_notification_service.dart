import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/notifications/model/device_token_registration_worker.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/work/ios_background_task_worker.dart';
import 'package:moniepoint_flutter/core/work/work_dispatcher.dart';
import 'package:workmanager/workmanager.dart';


FlutterLocalNotificationsPlugin _notificationPlugin = FlutterLocalNotificationsPlugin();

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

    await _notificationPlugin.initialize(_notificationInitializationSettings);
    await _retrieveFirebaseToken();
  }

  Future<void> _retrieveFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken().catchError((e) {
      _registerDeviceToken();
    });
    print("Token ====>>> $token");
    PreferenceUtil.saveValue(FCM_TOKEN, token);
    _registerDeviceToken();
  }

  void onMessageReceived(RemoteMessage message) {
    //TODO get message payload format
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

}

//When a message is received
Future<void> _onBackgroundMessageReceived(RemoteMessage message) async {
  //TODO get the data-payload to read
    RemoteNotification? notification = message.notification;

    final iosDetails = IOSNotificationDetails(
      badgeNumber: 0,
      subtitle: "Hello Notification",
    );

    final androidNotificationDetails = AndroidNotificationDetails(
        "Moniepoint", "Moniepoint App",
        channelDescription: "Test",
        priority: Priority.high
    );

    final details = NotificationDetails(
      iOS: iosDetails,
      android: androidNotificationDetails
    );

    _notificationPlugin.show(
        0,
        "Test",
        "Plain Body",
        details
    );
    print("Notification ===>>> ${message.data}");
    if(notification != null) {
      print("Notification ===>>> ${message.data}");
    }
}