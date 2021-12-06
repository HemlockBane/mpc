// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrowthNotification _$GrowthNotificationFromJson(Map<String, dynamic> json) {
  return GrowthNotification(
    id: json['id'] as int?,
    initiativeKey: json['initiativeKey'] as String?,
    customerId: json['customerId'] as int?,
    ranking: json['ranking'] as int?,
    notificationType: json['notificationType'] as String?,
    celebration: json['celebration'] as bool?,
    dismissible: json['dismissible'] as bool?,
  );
}

Map<String, dynamic> _$GrowthNotificationToJson(GrowthNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'initiativeKey': instance.initiativeKey,
      'customerId': instance.customerId,
      'ranking': instance.ranking,
      'notificationType': instance.notificationType,
      'celebration': instance.celebration,
      'dismissible': instance.dismissible,
    };

GrowthPopupNotification _$GrowthPopupNotificationFromJson(
    Map<String, dynamic> json) {
  return GrowthPopupNotification(
    htmlTemplate: json['htmlTemplate'] as String?,
    htmlBase64: json['htmlBase64'] as String?,
  )
    ..id = json['id'] as int?
    ..initiativeKey = json['initiativeKey'] as String?
    ..customerId = json['customerId'] as int?
    ..ranking = json['ranking'] as int?
    ..notificationType = json['notificationType'] as String?
    ..celebration = json['celebration'] as bool?
    ..dismissible = json['dismissible'] as bool?;
}

Map<String, dynamic> _$GrowthPopupNotificationToJson(
        GrowthPopupNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'initiativeKey': instance.initiativeKey,
      'customerId': instance.customerId,
      'ranking': instance.ranking,
      'notificationType': instance.notificationType,
      'celebration': instance.celebration,
      'dismissible': instance.dismissible,
      'htmlTemplate': instance.htmlTemplate,
      'htmlBase64': instance.htmlBase64,
    };

GrowthDashboardBanner _$GrowthDashboardBannerFromJson(
    Map<String, dynamic> json) {
  return GrowthDashboardBanner(
    message: json['message'] as String?,
    section: json['section'] as String?,
    backgroundColor: json['backgroundColor'] as String?,
    link: json['link'] as String?,
    image: json['image'] as String?,
  )
    ..id = json['id'] as int?
    ..initiativeKey = json['initiativeKey'] as String?
    ..customerId = json['customerId'] as int?
    ..ranking = json['ranking'] as int?
    ..notificationType = json['notificationType'] as String?
    ..celebration = json['celebration'] as bool?
    ..dismissible = json['dismissible'] as bool?;
}

Map<String, dynamic> _$GrowthDashboardBannerToJson(
        GrowthDashboardBanner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'initiativeKey': instance.initiativeKey,
      'customerId': instance.customerId,
      'ranking': instance.ranking,
      'notificationType': instance.notificationType,
      'celebration': instance.celebration,
      'dismissible': instance.dismissible,
      'message': instance.message,
      'section': instance.section,
      'backgroundColor': instance.backgroundColor,
      'link': instance.link,
      'image': instance.image,
    };
