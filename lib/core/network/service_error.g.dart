// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceError _$ServiceErrorFromJson(Map<String, dynamic> json) {
  return ServiceError(
    message: json['message'] as String,
    code: json['code'] as int?,
  );
}

Map<String, dynamic> _$ServiceErrorToJson(ServiceError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
    };
