// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_saving_config_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexSavingConfigRequestBody _$FlexSavingConfigRequestBodyFromJson(
    Map<String, dynamic> json) {
  return FlexSavingConfigRequestBody(
    flexSaveType:
        _$enumDecodeNullable(_$FlexSaveTypeEnumMap, json['flexSaveType']),
    flexSaveMode:
        _$enumDecodeNullable(_$FlexSaveModeEnumMap, json['flexSaveMode']),
    contributionWeekDay: json['contributionWeekDay'] as String?,
    contributionMonthDay: json['contributionMonthDay'] as int?,
    contributionAmount: (json['contributionAmount'] as num?)?.toDouble(),
    customerAccountId: json['customerAccountId'] as int?,
    customerId: json['customerId'] as int?,
    customerFlexSavingId: json['customerFlexSavingId'] as int?,
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$FlexSavingConfigRequestBodyToJson(
        FlexSavingConfigRequestBody instance) =>
    <String, dynamic>{
      'flexSaveType': _$FlexSaveTypeEnumMap[instance.flexSaveType],
      'flexSaveMode': _$FlexSaveModeEnumMap[instance.flexSaveMode],
      'contributionWeekDay': instance.contributionWeekDay,
      'contributionMonthDay': instance.contributionMonthDay,
      'contributionAmount': instance.contributionAmount,
      'customerAccountId': instance.customerAccountId,
      'customerId': instance.customerId,
      'customerFlexSavingId': instance.customerFlexSavingId,
      'name': instance.name,
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
