// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountCreationRequestBody _$AccountCreationRequestBodyFromJson(
    Map<String, dynamic> json) {
  return AccountCreationRequestBody()
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
    ..deviceName = json['deviceName'] as String?
    ..bvn = json['bvn'] as String?
    ..dateOfBirth = json['dob'] as String?
    ..phoneNumber = json['phoneNumber'] as String?
    ..emailAddress = json['emailAddress'] as String?
    ..firstName = json['firstName'] as String?
    ..surname = json['surname'] as String?
    ..gender = _$enumDecodeNullable(_$GenderEnumMap, json['gender'])
    ..otherName = json['otherName'] as String?
    ..ussdPin = json['ussdPin'] as String?
    ..transactionPin = json['transactionPin'] as String?
    ..createUssdPin = json['createUssd'] as bool
    ..selfieImageUUID = json['userImageUUID'] as String?
    ..signatureUUID = json['signatureUUID'] as String?
    ..livelinessCheck = json['livelinessCheck'] as String?
    ..stateOfOrigin = json['stateOfOrigin'] as String?
    ..localGovernmentAreaId = json['localGovernmentAreaId'] as String?;
}

Map<String, dynamic> _$AccountCreationRequestBodyToJson(
        AccountCreationRequestBody instance) =>
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
      'bvn': instance.bvn,
      'dob': instance.dateOfBirth,
      'phoneNumber': instance.phoneNumber,
      'emailAddress': instance.emailAddress,
      'firstName': instance.firstName,
      'surname': instance.surname,
      'gender': _$GenderEnumMap[instance.gender],
      'otherName': instance.otherName,
      'ussdPin': instance.ussdPin,
      'transactionPin': instance.transactionPin,
      'createUssd': instance.createUssdPin,
      'userImageUUID': instance.selfieImageUUID,
      'signatureUUID': instance.signatureUUID,
      'livelinessCheck': instance.livelinessCheck,
      'stateOfOrigin': instance.stateOfOrigin,
      'localGovernmentAreaId': instance.localGovernmentAreaId,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$GenderEnumMap = {
  Gender.MALE: 'MALE',
  Gender.FEMALE: 'FEMALE',
};
