// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryResponse _$RecoveryResponseFromJson(Map<String, dynamic> json) {
  return RecoveryResponse()
    ..livelinessError = json['livelinessError'] == null
        ? null
        : LivelinessError.fromJson(
            json['livelinessError'] as Map<String, dynamic>)
    ..faceMatchError = json['faceMatchError'] == null
        ? null
        : ClientError.fromJson(json['faceMatchError'] as Map<String, dynamic>)
    ..notificationServiceResponseCode =
        json['notificationServiceResponseCode'] as String?
    ..otpValidationKey = json['otpValidationKey'] as String?
    ..userCode = json['userCode'] as String?
    ..username = json['username'] as String?
    ..livelinessCheckRef = json['livelinessCheckRef'] as String?;
}

Map<String, dynamic> _$RecoveryResponseToJson(RecoveryResponse instance) =>
    <String, dynamic>{
      'livelinessError': instance.livelinessError,
      'faceMatchError': instance.faceMatchError,
      'notificationServiceResponseCode':
          instance.notificationServiceResponseCode,
      'otpValidationKey': instance.otpValidationKey,
      'userCode': instance.userCode,
      'username': instance.username,
      'livelinessCheckRef': instance.livelinessCheckRef,
    };
