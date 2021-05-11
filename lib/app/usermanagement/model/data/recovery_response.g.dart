// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryResponse _$RecoveryResponseFromJson(Map<String, dynamic> json) {
  return RecoveryResponse()
    ..activation = json['activation'] == null
        ? null
        : OTP.fromJson(json['activation'] as Object)
    ..securityQuestion = json['securityQuestion'] == null
        ? null
        : SecurityQuestion.fromJson(json['securityQuestion'] as Object)
    ..otp = json['otp'] == null ? null : OTP.fromJson(json['otp'] as Object)
    ..key = json['key'] as String?
    ..success = json['success'] as bool?;
}

Map<String, dynamic> _$RecoveryResponseToJson(RecoveryResponse instance) =>
    <String, dynamic>{
      'activation': instance.activation,
      'securityQuestion': instance.securityQuestion,
      'otp': instance.otp,
      'key': instance.key,
      'success': instance.success,
    };
