// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_phone_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidatePhoneOtpResponse _$ValidatePhoneOtpResponseFromJson(
    Map<String, dynamic> json) {
  return ValidatePhoneOtpResponse(
    json['phone_number_validation_key'] as String?,
  );
}

Map<String, dynamic> _$ValidatePhoneOtpResponseToJson(
        ValidatePhoneOtpResponse instance) =>
    <String, dynamic>{
      'phone_number_validation_key': instance.phoneNumberValidationKey,
    };
