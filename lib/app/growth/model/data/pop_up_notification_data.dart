import 'package:moniepoint_flutter/app/growth/growth_notification_data_type.dart';
import 'package:moniepoint_flutter/app/growth/model/growth_notification.dart';

///@author Paul Okeke
class PopUpNotificationData extends GrowthNotificationDataType {

  PopUpNotificationData._internal();

  late final List<GrowthPopupNotification> _popupNotification;

  ///An instance of PopUpNotificationData
  ///can only be created from this factory function
  factory PopUpNotificationData.of(List<GrowthPopupNotification> notification) {
    return PopUpNotificationData._internal().._popupNotification = notification;
  }

  List<GrowthPopupNotification> getData() => this._popupNotification;

}