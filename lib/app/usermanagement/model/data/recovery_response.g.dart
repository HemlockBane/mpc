// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryResponse _$RecoveryResponseFromJson(Map<String, dynamic> json) {
  return RecoveryResponse()
    ..notificationServiceResponseCode =
        json['notificationServiceResponseCode'] as String?
    ..otpValidationKey = json['otpValidationKey'] as String?
    ..userCode = json['userCode'] as String?;
}

Map<String, dynamic> _$RecoveryResponseToJson(RecoveryResponse instance) =>
    <String, dynamic>{
      'notificationServiceResponseCode':
          instance.notificationServiceResponseCode,
      'otpValidationKey': instance.otpValidationKey,
      'userCode': instance.userCode,
    };
