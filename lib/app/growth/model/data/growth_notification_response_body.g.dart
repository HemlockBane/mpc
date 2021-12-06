// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_notification_response_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrowthNotificationResponseBody _$GrowthNotificationResponseBodyFromJson(
    Map<String, dynamic> json) {
  return GrowthNotificationResponseBody(
    popUpNotifications: (json['popUpNotifications'] as List<dynamic>?)
        ?.map((e) => GrowthPopupNotification.fromJson(e as Object))
        .toList(),
    dashboardBanners: (json['dashboardBanners'] as List<dynamic>?)
        ?.map((e) => GrowthDashboardBanner.fromJson(e as Object))
        .toList(),
  );
}

Map<String, dynamic> _$GrowthNotificationResponseBodyToJson(
        GrowthNotificationResponseBody instance) =>
    <String, dynamic>{
      'popUpNotifications': instance.popUpNotifications,
      'dashboardBanners': instance.dashboardBanners,
    };
