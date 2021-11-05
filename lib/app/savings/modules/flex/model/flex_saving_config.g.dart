// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_saving_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexSavingConfig _$FlexSavingConfigFromJson(Map<String, dynamic> json) {
  return FlexSavingConfig(
    id: json['id'] as int,
    createdOn: stringDateTime(json['createdOn'] as String),
    version: json['version'] as int?,
    flexSaveType: json['flexSaveType'] as String?,
    flexSaveMode: json['flexSaveMode'] as String?,
    contributionWeekDay: json['contributionWeekDay'] as String?,
    contributionMonthDay: json['contributionMonthDay'] as int?,
    duration: json['duration'] as int?,
    contributionAmount: json['contributionAmount'] as int?,
    contributionAccount: json['contributionAccount'] == null
        ? null
        : CustomerAccount.fromJson(json['contributionAccount'] as Object),
    active: json['active'] as bool?,
  );
}

Map<String, dynamic> _$FlexSavingConfigToJson(FlexSavingConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdOn': millisToString(instance.createdOn),
      'version': instance.version,
      'flexSaveType': instance.flexSaveType,
      'flexSaveMode': instance.flexSaveMode,
      'contributionWeekDay': instance.contributionWeekDay,
      'contributionMonthDay': instance.contributionMonthDay,
      'duration': instance.duration,
      'contributionAmount': instance.contributionAmount,
      'contributionAccount': instance.contributionAccount,
      'active': instance.active,
    };
