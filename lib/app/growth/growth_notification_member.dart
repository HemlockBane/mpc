import 'package:moniepoint_flutter/app/growth/growth_notification_data_type.dart';

///@author Paul Okeke
///@class GrowthNotificationMember
///
/// e.g Consumer<GrowthNotificationDataType>
abstract class GrowthNotificationMember  {
  void accept(GrowthNotificationDataType event);
}