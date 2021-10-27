// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardTransactionRequest _$CardTransactionRequestFromJson(
    Map<String, dynamic> json) {
  return CardTransactionRequest()
    ..cardId = json['cardId'] as int?
    ..transactionChannel = _$enumDecodeNullable(
        _$TransactionChannelEnumMap, json['transactionChannel'])
    ..description = json['description'] as String?
    ..transactionPin = json['transactionPin'] as String?
    ..newPin = json['pin'] as String?
    ..oldPin = json['oldPin'] as String?
    ..cvv = json['cvv'] as String?
    ..expiry = json['expiry'] as String?
    ..cardAccountNumber = json['customerAccountNumber'] as String?;
}

Map<String, dynamic> _$CardTransactionRequestToJson(
    CardTransactionRequest instance) {
  final val = <String, dynamic>{
    'cardId': instance.cardId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('transactionChannel',
      _$TransactionChannelEnumMap[instance.transactionChannel]);
  writeNotNull('description', instance.description);
  val['transactionPin'] = instance.transactionPin;
  val['pin'] = instance.newPin;
  val['oldPin'] = instance.oldPin;
  val['cvv'] = instance.cvv;
  writeNotNull('expiry', instance.expiry);
  val['customerAccountNumber'] = instance.cardAccountNumber;
  return val;
}

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

const _$TransactionChannelEnumMap = {
  TransactionChannel.ALL: 'ALL',
  TransactionChannel.ATM: 'ATM',
  TransactionChannel.POS: 'POS',
  TransactionChannel.WEB: 'WEB',
  TransactionChannel.USSD: 'USSD',
  TransactionChannel.MOBILE: 'MOBILE',
};
