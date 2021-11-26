// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrowthNotification _$GrowthNotificationFromJson(Map<String, dynamic> json) {
  return GrowthNotification(
    customerId: json['customerId'] as int?,
    ranking: json['ranking'] as int?,
  );
}

Map<String, dynamic> _$GrowthNotificationToJson(GrowthNotification instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'ranking': instance.ranking,
    };

GrowthPopupNotification _$GrowthPopupNotificationFromJson(
    Map<String, dynamic> json) {
  return GrowthPopupNotification(
    htmlTemplate: json['htmlTemplate'] as String?,
  );
}

Map<String, dynamic> _$GrowthPopupNotificationToJson(
        GrowthPopupNotification instance) =>
    <String, dynamic>{
      'htmlTemplate': instance.htmlTemplate,
    };

GrowthDashboardBanner _$GrowthDashboardBannerFromJson(
    Map<String, dynamic> json) {
  return GrowthDashboardBanner();
}

Map<String, dynamic> _$GrowthDashboardBannerToJson(
        GrowthDashboardBanner instance) =>
    <String, dynamic>{};
