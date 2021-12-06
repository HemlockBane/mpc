import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/growth/growth_notification_data_type.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification.dart';
import 'package:moniepoint_flutter/app/growth/model/growth_notification_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'notification_status_type.dart';

///@author Paul Okeke
///
class DashboardBannerData extends GrowthNotificationDataType {

  DashboardBannerData._internal();

  late final List<GrowthDashboardBanner> _dashboardNotifications;

  factory DashboardBannerData.of(List<GrowthDashboardBanner> notification) {
    return DashboardBannerData._internal().._dashboardNotifications = notification;
  }

  List<GrowthDashboardBanner> getData() => this._dashboardNotifications;

  void update(NotificationStatusType statusType, GrowthDashboardBanner notification) async {
    if(statusType == NotificationStatusType.CLOSE) _dashboardNotifications.remove(notification);
    final growthServiceDelegate = GetIt.I<GrowthNotificationServiceDelegate>();
    print(jsonEncode(notification));
    final responseStream = growthServiceDelegate.updateNotificationStatus(notification.id ?? 0, statusType);
    await for (var response in responseStream) {
      if(response is Success ||response is Error) break;
    }
  }

}