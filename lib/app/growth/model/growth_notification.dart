import 'package:json_annotation/json_annotation.dart';

part 'growth_notification.g.dart';

@JsonSerializable()
class GrowthNotification {

  GrowthNotification({
    this.customerId,
    this.ranking
  });

  final int? customerId;
  final int? ranking;

  factory GrowthNotification.fromJson(Object? data) => _$GrowthNotificationFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$GrowthNotificationToJson(this);
}

@JsonSerializable()
class GrowthPopupNotification extends GrowthNotification {
  GrowthPopupNotification({
    this.htmlTemplate
  }):super();

  final String? htmlTemplate;

  factory GrowthPopupNotification.fromJson(Object? data) => _$GrowthPopupNotificationFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$GrowthPopupNotificationToJson(this);
}

@JsonSerializable()
class GrowthDashboardBanner extends GrowthNotification {

  GrowthDashboardBanner(): super();

  factory GrowthDashboardBanner.fromJson(Object? data) => _$GrowthDashboardBannerFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$GrowthDashboardBannerToJson(this);
}