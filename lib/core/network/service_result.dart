import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification_response_body.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';

part 'service_result.g.dart';

// -------------------------------------------------------------------
// Base Class for all Api Response
// -------------------------------------------------------------------
///@author Paul Okeke

@JsonSerializable(genericArgumentFactories: true)
class ServiceResult<ResultType> {
  ServiceResult(this.success, this.result, this.errors, this.growthNotifications);

  bool? success;
  @JsonKey(includeIfNull: false)
  final ResultType? result;
  final List<ServiceError>? errors;
  final GrowthNotificationResponseBody? growthNotifications;

  factory ServiceResult.fromJson(Map<String, dynamic> data, ResultType Function(Object? json) fromJsonT) =>
      _$ServiceResultFromJson(data, fromJsonT);

  Map<String, dynamic> toJson(
          Map<String, dynamic> Function(ResultType value) toJsonResultType) =>
      _$ServiceResultToJson(this, toJsonResultType);
}
