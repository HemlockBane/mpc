// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationKey _$ValidationKeyFromJson(Map<String, dynamic> json) {
  return ValidationKey()
    ..onboardingKey = json['onboardingKey'] as String?
    ..bankRegistration = json['bankRegistration'] as bool?
    ..existing = json['existing'] as bool?;
}

Map<String, dynamic> _$ValidationKeyToJson(ValidationKey instance) =>
    <String, dynamic>{
      'onboardingKey': instance.onboardingKey,
      'bankRegistration': instance.bankRegistration,
      'existing': instance.existing,
    };
