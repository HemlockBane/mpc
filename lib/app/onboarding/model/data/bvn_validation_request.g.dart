// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bvn_validation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BVNValidationRequest _$BVNValidationRequestFromJson(Map<String, dynamic> json) {
  return BVNValidationRequest()
    ..bvn = json['bvn'] as String?
    ..firstName = json['firstName'] as String?
    ..middleName = json['middleName'] as String?
    ..lastName = json['lastName'] as String?
    ..dob = json['dob'] as String?
    ..phoneNumber = json['phoneNumber'] as String?
    ..mobileNumber = json['mobileNo'] as String?
    ..emailAddress = json['emailAddress'] as String?
    ..otp = json['otp'] as String?
    ..gender = _$enumDecodeNullable(_$GenderEnumMap, json['gender']);
}

Map<String, dynamic> _$BVNValidationRequestToJson(
        BVNValidationRequest instance) =>
    <String, dynamic>{
      'bvn': instance.bvn,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'dob': instance.dob,
      'phoneNumber': instance.phoneNumber,
      'mobileNo': instance.mobileNumber,
      'emailAddress': instance.emailAddress,
      'otp': instance.otp,
      'gender': _$GenderEnumMap[instance.gender],
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
