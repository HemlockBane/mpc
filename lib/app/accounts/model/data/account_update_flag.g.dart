// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_update_flag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountUpdateFlag _$AccountUpdateFlagFromJson(Map<String, dynamic> json) {
  return AccountUpdateFlag(
    json['status'] as bool,
    json['weight'] as int,
    json['verificationEndTime'] as String?,
    _$enumDecodeNullable(
        _$VerificationStateEnumMap, json['verificationStates']),
  );
}

Map<String, dynamic> _$AccountUpdateFlagToJson(AccountUpdateFlag instance) =>
    <String, dynamic>{
      'status': instance.status,
      'weight': instance.weight,
      'verificationEndTime': instance.verificationEndTime,
      'verificationStates':
          _$VerificationStateEnumMap[instance.verificationStates],
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

const _$VerificationStateEnumMap = {
  VerificationState.PENDING: 'PENDING',
  VerificationState.INPROGRESS: 'INPROGRESS',
  VerificationState.PASSED: 'PASSED',
  VerificationState.FAILED: 'FAILED',
};
