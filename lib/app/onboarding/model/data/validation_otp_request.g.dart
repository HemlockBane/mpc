// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateOtpRequestBody _$ValidateOtpRequestBodyFromJson(
    Map<String, dynamic> json) {
  return ValidateOtpRequestBody()
    ..accountNumber = json['accountNumber'] as String?
    ..userCode = json['userCode'] as String?
    ..otp = json['otp'] as String?;
}

Map<String, dynamic> _$ValidateOtpRequestBodyToJson(
        ValidateOtpRequestBody instance) =>
    <String, dynamic>{
      'accountNumber': instance.accountNumber,
      'userCode': instance.userCode,
      'otp': instance.otp,
    };
