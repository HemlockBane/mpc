// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientError _$ClientErrorFromJson(Map<String, dynamic> json) {
  return ClientError(
    code: json['code'] as String?,
    message: json['message'] as String?,
  );
}

Map<String, dynamic> _$ClientErrorToJson(ClientError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
