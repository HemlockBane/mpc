import 'package:json_annotation/json_annotation.dart';

import 'growth_notification.dart';

part 'growth_notification_response_body.g.dart';

@JsonSerializable()
class GrowthNotificationResponseBody  {

  GrowthNotificationResponseBody({
    this.popUpNotifications,
    this.dashboardBanners
  });

  final List<GrowthPopupNotification>? popUpNotifications;
  final List<GrowthDashboardBanner>? dashboardBanners;

  factory GrowthNotificationResponseBody.fromJson(Object? data) {
    return _$GrowthNotificationResponseBodyFromJson(data as Map<String, dynamic>);
  }
  Map<String, dynamic> toJson() => _$GrowthNotificationResponseBodyToJson(this);

}
