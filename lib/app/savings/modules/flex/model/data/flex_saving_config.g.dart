// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_saving_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexSavingConfig _$FlexSavingConfigFromJson(Map<String, dynamic> json) {
  return FlexSavingConfig(
    id: json['flexSavingConfigId'] as int,
    createdOn: stringDateTime(json['createdOn'] as String?),
    version: json['version'] as int?,
    flexSaveType:
        _$enumDecodeNullable(_$FlexSaveTypeEnumMap, json['flexSaveType']),
    flexSaveMode:
        _$enumDecodeNullable(_$FlexSaveModeEnumMap, json['flexSaveMode']),
    contributionWeekDay: json['contributionWeekDay'] as String?,
    contributionMonthDay: json['contributionMonthDay'] as int?,
    duration: json['duration'] as int?,
    contributionAmount: json['contributionAmount'] as int?,
    contributionAccount: json['contributionAccount'] == null
        ? null
        : CustomerAccount.fromJson(json['contributionAccount'] as Object),
    customerAccountId: json['customerAccountId'] as int?,
    customerId: json['customerId'] as int?,
    active: json['active'] as bool?,
    customerFlexSavingId: json['customerFlexSavingId'] as int?,
  );
}

Map<String, dynamic> _$FlexSavingConfigToJson(FlexSavingConfig instance) =>
    <String, dynamic>{
      'flexSavingConfigId': instance.id,
      'createdOn': millisToString(instance.createdOn),
      'version': instance.version,
      'flexSaveType': _$FlexSaveTypeEnumMap[instance.flexSaveType],
      'flexSaveMode': _$FlexSaveModeEnumMap[instance.flexSaveMode],
      'contributionWeekDay': instance.contributionWeekDay,
      'contributionMonthDay': instance.contributionMonthDay,
      'duration': instance.duration,
      'contributionAmount': instance.contributionAmount,
      'contributionAccount': instance.contributionAccount,
      'customerAccountId': instance.customerAccountId,
      'customerId': instance.customerId,
      'active': instance.active,
      'customerFlexSavingId': instance.customerFlexSavingId,
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

const _$FlexSaveTypeEnumMap = {
  FlexSaveType.AUTOMATIC: 'AUTOMATIC',
  FlexSaveType.MANUAL: 'MANUAL',
};

const _$FlexSaveModeEnumMap = {
  FlexSaveMode.MONTHLY: 'MONTHLY',
  FlexSaveMode.WEEKLY: 'WEEKLY',
};
