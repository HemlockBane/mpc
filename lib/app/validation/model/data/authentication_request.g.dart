// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationRequest _$AuthenticationRequestFromJson(
    Map<String, dynamic> json) {
  return AuthenticationRequest()
    ..authenticationType = json['authenticationType'] as String?
    ..otp = json['otp'] as String?
    ..userCode = json['userCode'] as String?;
}

Map<String, dynamic> _$AuthenticationRequestToJson(
        AuthenticationRequest instance) =>
    <String, dynamic>{
      'authenticationType': instance.authenticationType,
      'otp': instance.otp,
      'userCode': instance.userCode,
    };
