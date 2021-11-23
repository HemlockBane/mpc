// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enable_flex_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnableFlexRequestBody _$EnableFlexRequestBodyFromJson(
    Map<String, dynamic> json) {
  return EnableFlexRequestBody(
    customerId: json['customerId'] as String?,
    flexVersion: json['flexVersion'] as String?,
  );
}

Map<String, dynamic> _$EnableFlexRequestBodyToJson(
        EnableFlexRequestBody instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'flexVersion': instance.flexVersion,
    };
