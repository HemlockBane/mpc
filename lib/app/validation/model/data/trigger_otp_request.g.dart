// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trigger_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TriggerOtpRequestBody _$TriggerOtpRequestBodyFromJson(
    Map<String, dynamic> json) {
  return TriggerOtpRequestBody()
    ..username = json['username'] as String?
    ..customerType = json['customerType'] as String?
    ..validationKey = json['validationKey'] as String?;
}

Map<String, dynamic> _$TriggerOtpRequestBodyToJson(
        TriggerOtpRequestBody instance) =>
    <String, dynamic>{
      'username': instance.username,
      'customerType': instance.customerType,
      'validationKey': instance.validationKey,
    };
