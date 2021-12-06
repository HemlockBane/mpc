// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexTransaction _$FlexTransactionFromJson(Map<String, dynamic> json) {
  return FlexTransaction(
    transactionDate: stringDateTime(json['transactionDate'] as String?),
    transactionRef: json['transactionRef'] as String,
    status: json['status'] as bool?,
    amount: (json['amount'] as num?)?.toDouble(),
    accountNumber: json['accountNumber'] as String?,
    type: _$enumDecodeNullable(_$TransactionTypeEnumMap, json['type']),
    transactionChannel: json['transactionChannel'] as String?,
    tags: json['tags'] as String?,
    narration: json['narration'] as String?,
    runningBalance: json['runningBalance'] as String?,
    balanceBefore: json['balanceBefore'] as String?,
    balanceAfter: json['balanceAfter'] as String?,
    metaData: json['metaDataObj'] == null
        ? null
        : TransactionMetaData.fromJson(json['metaDataObj'] as Object),
    transactionCategory: _$enumDecodeNullable(
        _$TransactionCategoryEnumMap, json['transactionCategory']),
    transactionCode: json['transactionCode'] as String?,
    beneficiaryIdentifier: json['beneficiaryIdentifier'] as String?,
    beneficiaryName: json['beneficiaryName'] as String?,
    beneficiaryBankName: json['beneficiaryBankName'] as String?,
    beneficiaryBankCode: json['beneficiaryBankCode'] as String?,
    senderIdentifier: json['senderIdentifier'] as String?,
    senderName: json['senderName'] as String?,
    senderBankName: json['senderBankName'] as String?,
    senderBankCode: json['senderBankCode'] as String?,
    providerIdentifier: json['providerIdentifier'] as String?,
    providerName: json['providerName'] as String?,
    transactionIdentifier: json['transactionIdentifier'] as String?,
    merchantLocation: json['merchantLocation'] as String?,
    cardScheme: json['cardScheme'] as String?,
    maskedPan: json['maskedPan'] as String?,
    terminalID: json['terminalId'] as String?,
    disputable: json['disputable'] as bool?,
    location: json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Object),
    flexSavingId: json['flexSavingId'] as int?,
  );
}

Map<String, dynamic> _$FlexTransactionToJson(FlexTransaction instance) =>
    <String, dynamic>{
      'accountNumber': instance.accountNumber,
      'status': instance.status,
      'transactionRef': instance.transactionRef,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type],
      'transactionChannel': instance.transactionChannel,
      'tags': instance.tags,
      'narration': instance.narration,
      'transactionDate': millisToString(instance.transactionDate),
      'runningBalance': instance.runningBalance,
      'balanceBefore': instance.balanceBefore,
      'balanceAfter': instance.balanceAfter,
      'transactionCategory':
          _$TransactionCategoryEnumMap[instance.transactionCategory],
      'transactionCode': instance.transactionCode,
      'beneficiaryIdentifier': instance.beneficiaryIdentifier,
      'beneficiaryName': instance.beneficiaryName,
      'beneficiaryBankName': instance.beneficiaryBankName,
      'beneficiaryBankCode': instance.beneficiaryBankCode,
      'senderIdentifier': instance.senderIdentifier,
      'senderName': instance.senderName,
      'senderBankName': instance.senderBankName,
      'senderBankCode': instance.senderBankCode,
      'providerIdentifier': instance.providerIdentifier,
      'providerName': instance.providerName,
      'transactionIdentifier': instance.transactionIdentifier,
      'merchantLocation': instance.merchantLocation,
      'cardScheme': instance.cardScheme,
      'maskedPan': instance.maskedPan,
      'terminalId': instance.terminalID,
      'disputable': instance.disputable,
      'location': instance.location,
      'metaDataObj': instance.metaData,
      'flexSavingId': instance.flexSavingId,
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
  TransactionType.ALL: 'ALL',
  TransactionType.DEBIT: 'DEBIT',
  TransactionType.CREDIT: 'CREDIT',
  TransactionType.UNKNOWN: 'UNKNOWN',
};

const _$TransactionCategoryEnumMap = {
  TransactionCategory.TRANSFER: 'TRANSFER',
  TransactionCategory.BILL_PAYMENT: 'BILL_PAYMENT',
  TransactionCategory.AIRTIME: 'AIRTIME',
  TransactionCategory.DATA: 'DATA',
  TransactionCategory.CARD_LINKING: 'CARD_LINKING',
  TransactionCategory.CARD_PURCHASE: 'CARD_PURCHASE',
  TransactionCategory.FLEX_SAVING_AUTOSAVE: 'FLEX_SAVING_AUTOSAVE',
  TransactionCategory.DEFAULT: 'DEFAULT',
};
