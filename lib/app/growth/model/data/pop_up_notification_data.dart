import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/growth/growth_notification_data_type.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification.dart';
import 'package:moniepoint_flutter/app/growth/views/pop_up_notification_route.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import '../growth_notification_service_delegate.dart';
import 'notification_status_type.dart';

///@author Paul Okeke
class PopUpNotificationData extends GrowthNotificationDataType {

  PopUpNotificationData._internal();

  late final List<GrowthPopupNotification> _popupNotifications;

  ///An instance of PopUpNotificationData
  ///can only be created from this factory function
  factory PopUpNotificationData.of(List<GrowthPopupNotification> notification) {
    return PopUpNotificationData._internal().._popupNotifications = notification.map((e) {
      if(e.htmlTemplate == null) return e;
      e.htmlBase64 = "data:text/html;base64,${base64Encode(const Utf8Encoder().convert(e.htmlTemplate!))}";
      return e;
    }).toList();
  }

  List<GrowthPopupNotification> getData() => this._popupNotifications;

  void update(NotificationStatusType statusType, GrowthPopupNotification notification) async {
    if(statusType == NotificationStatusType.CLOSE) _popupNotifications.remove(notification);
    final growthServiceDelegate = GetIt.I<GrowthNotificationServiceDelegate>();
    final responseStream = growthServiceDelegate.updateNotificationStatus(notification.id ?? 0, statusType);
    await for (var response in responseStream) {
      if(response is Success ||response is Error) break;
    }
  }

}