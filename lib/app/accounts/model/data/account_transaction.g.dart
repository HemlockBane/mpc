// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountTransaction _$AccountTransactionFromJson(Map<String, dynamic> json) {
  return AccountTransaction(
    id: json['id'] as int?,
    transactionDate: stringDateTime(json['transactionDate'] as String),
    transactionRef: json['transactionRef'] as String,
    status: json['status'] as bool?,
    amount: (json['amount'] as num?)?.toDouble(),
    type: _$enumDecodeNullable(_$TransactionTypeEnumMap, json['type']),
    channel: json['channel'] as String?,
    transactionChannel: _$enumDecodeNullable(
        _$TransactionChannelEnumMap, json['transactionChannel']),
    tags: json['tags'] as String?,
    narration: json['narration'] as String?,
    runningBalance: json['runningBalance'] as String?,
    balanceBefore: json['balanceBefore'] as String?,
    balanceAfter: json['balanceAfter'] as String?,
    metaData: json['metaDataObj'] == null
        ? null
        : TransactionMetaData.fromJson(json['metaDataObj'] as Object),
  );
}

Map<String, dynamic> _$AccountTransactionToJson(AccountTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'transactionRef': instance.transactionRef,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type],
      'channel': instance.channel,
      'transactionChannel':
          _$TransactionChannelEnumMap[instance.transactionChannel],
      'tags': instance.tags,
      'narration': instance.narration,
      'transactionDate': instance.transactionDate,
      'runningBalance': instance.runningBalance,
      'balanceBefore': instance.balanceBefore,
      'balanceAfter': instance.balanceAfter,
      'metaDataObj': instance.metaData,
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

const _$TransactionTypeEnumMap = {
  TransactionType.DEBIT: 'DEBIT',
  TransactionType.CREDIT: 'CREDIT',
  TransactionType.UNKNOWN: 'UNKNOWN',
};

const _$TransactionChannelEnumMap = {
  TransactionChannel.ATM: 'ATM',
  TransactionChannel.POS: 'POS',
  TransactionChannel.WEB: 'WEB',
  TransactionChannel.USSD: 'USSD',
  TransactionChannel.MOBILE: 'MOBILE',
  TransactionChannel.KIOSK: 'KIOSK',
};
