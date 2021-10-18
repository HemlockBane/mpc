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

    if(hasRegisteredDevice == true) return true;

    if(token == null || token is String && token.isEmpty) {
      return false;
    }

    await for(var response in this._notificationServiceDelegate.registerDeviceToken(token)) {
      if(response is Success) {
        PreferenceUtil.saveValue(AppNotificationService.FCM_TOKEN_REGISTERED, true);
      }
      else if(response is Error<String?>) {
        PreferenceUtil.saveValue(AppNotificationService.FCM_TOKEN_REGISTERED, false);
        if(response.message?.contains("internet connection") == true
            || response.message?.contains("service at this time") == true ) {
          return false;
        }
        return Future.error(response);
      }
    }
    return true;
  }

}