import 'package:moniepoint_flutter/app/growth/growth_notification_data_bus.dart';

///@author Paul Okeke
///
abstract class GrowthNotificationDataType {
  GrowthNotificationDataBus? _dataBus;

  void setDataBus(GrowthNotificationDataBus dataBus){
    this._dataBus = dataBus;
  }

  GrowthNotificationDataBus? getDataBus() {
    return this._dataBus;
  }

}