import 'package:json_annotation/json_annotation.dart';

part 'growth_notification.g.dart';

///@author Paul Okeke

///GrowthNotification
///
///
@JsonSerializable()
class GrowthNotification {

  GrowthNotification({
    this.id,
    this.initiativeKey,
    this.customerId,
    this.ranking,
    this.notificationType,
    this.celebration,
    this.dismissible
  });

  int? id;
  String? initiativeKey;
  int? customerId;
  int? ranking;
  String? notificationType;
  bool? celebration;
  bool? dismissible;

  factory GrowthNotification.fromJson(Object? data) => _$GrowthNotificationFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$GrowthNotificationToJson(this);
}


///GrowthPopupNotification
///
///
@JsonSerializable()
class GrowthPopupNotification extends GrowthNotification {
  GrowthPopupNotification({
    this.htmlTemplate,
    this.htmlBase64
  }) : super();

  final String? htmlTemplate;
  String? htmlBase64;

  factory GrowthPopupNotification.fromJson(Object? data) => _$GrowthPopupNotificationFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$GrowthPopupNotificationToJson(this);
}


///GrowthDashboardBanner
///
///
@JsonSerializable()
class GrowthDashboardBanner extends GrowthNotification {

  GrowthDashboardBanner({
    this.message,
    this.section,
    this.backgroundColor,
    this.link,
    this.image,
  }): super();

  final String? message;
  final String? section;
  final String? backgroundColor;
  final String? link;
  final String? image;

  factory GrowthDashboardBanner.fromJson(Object? data) => _$GrowthDashboardBannerFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$GrowthDashboardBannerToJson(this);
}