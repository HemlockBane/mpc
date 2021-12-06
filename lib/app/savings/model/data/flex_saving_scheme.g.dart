// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_saving_scheme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexSavingScheme _$FlexSavingSchemeFromJson(Map<String, dynamic> json) {
  return FlexSavingScheme(
    id: json['id'] as int?,
    name: json['name'] as String?,
    accountSchemeCode: json['accountSchemeCode'] as String?,
    isDefault: json['default'] as bool?,
  );
}

Map<String, dynamic> _$FlexSavingSchemeToJson(FlexSavingScheme instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'accountSchemeCode': instance.accountSchemeCode,
      'default': instance.isDefault,
    };
