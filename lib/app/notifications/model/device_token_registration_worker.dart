import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/work/worker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_notification_service.dart';
import 'notification_service_delegate.dart';


class DeviceTokenRegistrationWorker extends Worker {

  static const WORKER_KEY = "DeviceTokenRegistrationWorker";

  late final NotificationServiceDelegate _notificationServiceDelegate;

  DeviceTokenRegistrationWorker({NotificationServiceDelegate? delegate}) {
    this._notificationServiceDelegate = delegate ?? GetIt.I<NotificationServiceDelegate>();
  }

  @override
  Future<bool> execute(Map<String, dynamic>? inputData) async {
    final token = PreferenceUtil.getValue(AppNotificationService.FCM_TOKEN);
    final hasRegisteredDevice = PreferenceUtil.getValue(AppNotificationService.FCM_TOKEN_REGISTERED) as bool?;

    print("About to register Device!!!! ===> $token");
    if(hasRegisteredDevice == true) return true;

    if(token == null || token is String && token.isEmpty) {
      return false;
    }

    this._notificationServiceDelegate.registerDeviceToken(token).listen((event) {
      if(event is Success) {
        PreferenceUtil.saveValue(AppNotificationService.FCM_TOKEN_REGISTERED, true);
      }
      else if(event is Error<bool>) {
        PreferenceUtil.saveValue(AppNotificationService.FCM_TOKEN_REGISTERED, false);
      }
    });
    return true;
  }

}