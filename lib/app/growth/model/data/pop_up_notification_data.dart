import 'dart:convert';

import 'package:moniepoint_flutter/app/growth/growth_notification_data_type.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification.dart';
import 'package:moniepoint_flutter/app/growth/views/pop_up_notification_route.dart';

///@author Paul Okeke
class PopUpNotificationData extends GrowthNotificationDataType {

  PopUpNotificationData._internal();

  late final List<GrowthPopupNotification> _popupNotification;

  ///An instance of PopUpNotificationData
  ///can only be created from this factory function
  factory PopUpNotificationData.of(List<GrowthPopupNotification> notification) {
    return PopUpNotificationData._internal().._popupNotification = notification.map((e) {
      if(e.htmlTemplate == null) return e;
      e.htmlBase64 = "data:text/html;base64,${base64Encode(const Utf8Encoder().convert(e.htmlTemplate!))}";
      return e;
    }).toList();
  }

  List<GrowthPopupNotification> getData() => this._popupNotification;

}