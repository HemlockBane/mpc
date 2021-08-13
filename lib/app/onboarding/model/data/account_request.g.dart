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
    ..emailAddress = json['emailAddress'] as String?
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
    ..addressInfo = json['addressInfo'] == null
        ? null
        : AddressInfo.fromJson(json['addressInfo'] as Object)
    ..setupType = json['setupType'] == null
        ? null
        : SetupType.fromJson(json['setupType'] as Object);
}

Map<String, dynamic> _$AccountCreationRequestBodyToJson(
    AccountCreationRequestBody instance) {
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
  val['bvn'] = instance.bvn;
  val['dob'] = instance.dateOfBirth;
  val['phoneNumber'] = instance.phoneNumber;
  val['firstName'] = instance.firstName;
  val['surname'] = instance.surname;
  val['gender'] = _$GenderEnumMap[instance.gender];
  val['otherName'] = instance.otherName;
  val['ussdPin'] = instance.ussdPin;
  val['transactionPin'] = instance.transactionPin;
  val['createUssd'] = instance.createUssdPin;
  val['userImageUUID'] = instance.selfieImageUUID;
  val['signatureUUID'] = instance.signatureUUID;
  val['livelinessCheck'] = instance.livelinessCheck;
  val['addressInfo'] = instance.addressInfo;
  val['setupType'] = instance.setupType;
  return val;
}

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
