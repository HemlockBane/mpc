// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_saving_interest_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexSavingInterestProfile _$FlexSavingInterestProfileFromJson(
    Map<String, dynamic> json) {
  return FlexSavingInterestProfile(
    id: json['id'] as int?,
    interestProfileCode: json['interestProfileCode'] as String?,
    interestRate: (json['interestRate'] as num?)?.toDouble(),
    isDefault: json['default'] as bool?,
  );
}

Map<String, dynamic> _$FlexSavingInterestProfileToJson(
        FlexSavingInterestProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'interestProfileCode': instance.interestProfileCode,
      'interestRate': instance.interestRate,
      'default': instance.isDefault,
    };
