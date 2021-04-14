// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileCreationRequestBody _$ProfileCreationRequestBodyFromJson(
    Map<String, dynamic> json) {
  return ProfileCreationRequestBody()
    ..accountNumber = json['accountNumber'] as String?
    ..referralCode = json['referralCode'] as String?
    ..username = json['username'] as String?
    ..password = json['password'] as String?
    ..pin = json['pin'] as String?
    ..onboardingKey = json['onboardingKey'] as String?
    ..securityAnwsers = (json['securityAnswers'] as List<dynamic>)
        .map((e) => SecurityAnswer.fromJson(e as Map<String, dynamic>))
        .toList()
    ..deviceId = json['deviceId'] as String?
    ..deviceName = json['deviceName'] as String?;
}

Map<String, dynamic> _$ProfileCreationRequestBodyToJson(
        ProfileCreationRequestBody instance) =>
    <String, dynamic>{
      'accountNumber': instance.accountNumber,
      'referralCode': instance.referralCode,
      'username': instance.username,
      'password': instance.password,
      'pin': instance.pin,
      'onboardingKey': instance.onboardingKey,
      'securityAnswers': instance.securityAnwsers,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
    };
