// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceResult<ResultType> _$ServiceResultFromJson<ResultType>(
  Map<String, dynamic> json,
  ResultType Function(Object? json) fromJsonResultType,
) {
  return ServiceResult<ResultType>(
    json['success'] as bool?,
    _$nullableGenericFromJson(json['result'], fromJsonResultType),
    (json['errors'] as List<dynamic>?)
        ?.map((e) => ServiceError.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['growthNotifications'] == null
        ? null
        : GrowthNotificationResponseBody.fromJson(
            json['growthNotifications'] as Object),
  );
}

Map<String, dynamic> _$ServiceResultToJson<ResultType>(
  ServiceResult<ResultType> instance,
  Object? Function(ResultType value) toJsonResultType,
) {
  final val = <String, dynamic>{
    'success': instance.success,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'result', _$nullableGenericToJson(instance.result, toJsonResultType));
  val['errors'] = instance.errors;
  val['growthNotifications'] = instance.growthNotifications;
  return val;
}

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
