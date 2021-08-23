// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_device_switch_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateDeviceSwitchRequestBody _$ValidateDeviceSwitchRequestBodyFromJson(
    Map<String, dynamic> json) {
  return ValidateDeviceSwitchRequestBody()
    ..username = json['username'] as String?
    ..customerType = json['customerType'] as String?
    ..validationKey = json['validationKey'] as String?
    ..otp = json['otp'] as String?
    ..userCode = json['userCode'] as String?;
}

Map<String, dynamic> _$ValidateDeviceSwitchRequestBodyToJson(
        ValidateDeviceSwitchRequestBody instance) =>
    <String, dynamic>{
      'username': instance.username,
      'customerType': instance.customerType,
      'validationKey': instance.validationKey,
      'otp': instance.otp,
      'userCode': instance.userCode,
    };
