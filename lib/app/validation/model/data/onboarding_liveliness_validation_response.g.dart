// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_liveliness_validation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingLivelinessValidationResponse
    _$OnboardingLivelinessValidationResponseFromJson(
        Map<String, dynamic> json) {
  return OnboardingLivelinessValidationResponse(
    livelinessError: json['livelinessError'] == null
        ? null
        : LivelinessError.fromJson(
            json['livelinessError'] as Map<String, dynamic>),
    faceMatchError: json['faceMatchError'] == null
        ? null
        : ClientError.fromJson(json['faceMatchError'] as Map<String, dynamic>),
    phoneNumberUniquenessError: json['phoneNumberUniquenessError'] == null
        ? null
        : ClientError.fromJson(
            json['phoneNumberUniquenessError'] as Map<String, dynamic>),
    phoneMismatchError: json['phoneMismatchError'] == null
        ? null
        : ClientError.fromJson(
            json['phoneMismatchError'] as Map<String, dynamic>),
    setupType: json['setupType'] == null
        ? null
        : SetupType.fromJson(json['setupType'] as Object),
    onboardingKey: json['onboardingKey'] as String?,
    mobileProfileExist: json['mobileProfileExist'] as bool?,
  );
}

Map<String, dynamic> _$OnboardingLivelinessValidationResponseToJson(
        OnboardingLivelinessValidationResponse instance) =>
    <String, dynamic>{
      'livelinessError': instance.livelinessError,
      'faceMatchError': instance.faceMatchError,
      'phoneNumberUniquenessError': instance.phoneNumberUniquenessError,
      'phoneMismatchError': instance.phoneMismatchError,
      'setupType': instance.setupType,
      'onboardingKey': instance.onboardingKey,
      'mobileProfileExist': instance.mobileProfileExist,
    };

SetupType _$SetupTypeFromJson(Map<String, dynamic> json) {
  return SetupType(
    type: _$enumDecodeNullable(_$OnBoardingTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$SetupTypeToJson(SetupType instance) => <String, dynamic>{
      'type': _$OnBoardingTypeEnumMap[instance.type],
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

const _$OnBoardingTypeEnumMap = {
  OnBoardingType.ACCOUNT_EXIST: 'ACCOUNT_EXIST',
  OnBoardingType.ACCOUNT_DOES_NOT_EXIST: 'ACCOUNT_DOES_NOT_EXIST',
};
