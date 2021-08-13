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
    ..emailAddress = json['emailAddress'] as String?
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
    ProfileCreationRequestBody instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('accountNumber', instance.accountNumber);
  writeNotNull('referralCode', instance.referralCode);
  writeNotNull('username', instance.username);
  writeNotNull('emailAddress', instance.emailAddress);
  writeNotNull('password', instance.password);
  writeNotNull('pin', instance.pin);
  writeNotNull('onboardingKey', instance.onboardingKey);
  val['securityAnswers'] = instance.securityAnwsers;
  writeNotNull('deviceId', instance.deviceId);
  writeNotNull('deviceName', instance.deviceName);
  return val;
}
