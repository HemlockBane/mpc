// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_saving_scheme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexSavingScheme _$FlexSavingSchemeFromJson(Map<String, dynamic> json) {
  return FlexSavingScheme(
    id: json['id'] as int?,
    name: json['name'] as String?,
    interestRate: (json['interestRate'] as num?)?.toDouble(),
    accountSchemeCode: json['accountSchemeCode'] as String?,
  );
}

Map<String, dynamic> _$FlexSavingSchemeToJson(FlexSavingScheme instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'interestRate': instance.interestRate,
      'accountSchemeCode': instance.accountSchemeCode,
    };
