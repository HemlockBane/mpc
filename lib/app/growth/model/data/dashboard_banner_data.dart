import 'package:moniepoint_flutter/app/growth/growth_notification_data_type.dart';
import 'package:moniepoint_flutter/app/growth/model/growth_notification.dart';

///@author Paul Okeke
///
class DashboardBannerData extends GrowthNotificationDataType {

  GrowthDashboardBanner? _banner;

  static DashboardBannerData of(GrowthDashboardBanner banner) {
    return DashboardBannerData().._banner = banner;
  }

  void dismiss() {

  }

}