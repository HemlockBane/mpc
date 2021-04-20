// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTP _$OTPFromJson(Map<String, dynamic> json) {
  return OTP()
    ..response = json['response'] == null
        ? null
        : Response.fromJson(json['response'] as Object)
    ..phoneNumber = json['phoneNumber'] as String?
    ..email = json['email'] as String?
    ..userCode = json['userCode'] as String?
    ..narration = json['narration'] as String?
    ..notificationServiceResponseCode =
        json['notificationServiceResponseCode'] as String?;
}

Map<String, dynamic> _$OTPToJson(OTP instance) => <String, dynamic>{
      'response': instance.response,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'userCode': instance.userCode,
      'narration': instance.narration,
      'notificationServiceResponseCode':
          instance.notificationServiceResponseCode,
    };
