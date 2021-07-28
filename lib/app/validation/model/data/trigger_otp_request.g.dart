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
    TriggerOtpRequestBody instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('username', instance.username);
  writeNotNull('customerType', instance.customerType);
  writeNotNull('validationKey', instance.validationKey);
  return val;
}
