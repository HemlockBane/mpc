// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionBatch _$TransactionBatchFromJson(Map<String, dynamic> json) {
  return TransactionBatch(
    id: json['id'] as int?,
    batchKey: json['batchKey'] as String?,
    sourceAccountProviderCode: json['sourceAccountProviderCode'] as String?,
    sourceAccountProviderName: json['sourceAccountProviderName'] as String?,
    sourceAccountNumber: json['sourceAccountNumber'] as String?,
    currencyCode: json['currencyCode'] as String?,
    initiator: json['initiator'] as String?,
    status: json['status'] as String?,
    paymentType:
        _$enumDecodeNullable(_$PaymentTypeEnumMap, json['paymentType']),
    paymentInterval: json['paymentInterval'] as String?,
    responseCode: json['responseCode'] as String?,
    comment: json['comment'] as String?,
    count: json['count'] as int?,
    createdOn:
        (json['createdOn'] as List<dynamic>?)?.map((e) => e as int).toList(),
    minorTotalAmount: (json['minorTotalAmount'] as num?)?.toDouble(),
    transactionStatus: json['transactionStatus'] as String?,
    paymentMethod: json['paymentMethod'] as String?,
    paymentStartDate: (json['paymentStartDate'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList(),
    nextPaymentDate: (json['nextPaymentDate'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList(),
    paymentEndDate: (json['paymentEndDate'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList(),
    startPayDate: json['startPayDate'] as int?,
    nextPayDate: json['nextPayDate'] as int?,
    endPayDate: json['endPayDate'] as int?,
    creationDate: json['creationDate'] as int?,
    transactionName: json['transactionName'] as String?,
    completedOn:
        (json['completedOn'] as List<dynamic>?)?.map((e) => e as int).toList(),
    tracked: json['tracked'] as bool?,
    rechargeDate: json['rechargeDate'] as int?,
    creationTimeStamp: json['creationTimeStamp'] as int?,
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$TransactionBatchToJson(TransactionBatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'batchKey': instance.batchKey,
      'sourceAccountProviderCode': instance.sourceAccountProviderCode,
      'sourceAccountProviderName': instance.sourceAccountProviderName,
      'sourceAccountNumber': instance.sourceAccountNumber,
      'currencyCode': instance.currencyCode,
      'initiator': instance.initiator,
      'status': instance.status,
      'paymentType': _$PaymentTypeEnumMap[instance.paymentType],
      'paymentInterval': instance.paymentInterval,
      'responseCode': instance.responseCode,
      'comment': instance.comment,
      'count': instance.count,
      'createdOn': instance.createdOn,
      'minorTotalAmount': instance.minorTotalAmount,
      'transactionStatus': instance.transactionStatus,
      'paymentMethod': instance.paymentMethod,
      'paymentStartDate': instance.paymentStartDate,
      'nextPaymentDate': instance.nextPaymentDate,
      'paymentEndDate': instance.paymentEndDate,
      'startPayDate': instance.startPayDate,
      'nextPayDate': instance.nextPayDate,
      'endPayDate': instance.endPayDate,
      'creationDate': instance.creationDate,
      'transactionName': instance.transactionName,
      'completedOn': instance.completedOn,
      'tracked': instance.tracked,
      'rechargeDate': instance.rechargeDate,
      'creationTimeStamp': instance.creationTimeStamp,
      'token': instance.token,
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

const _$PaymentTypeEnumMap = {
  PaymentType.ONE_TIME: 'ONE_TIME',
};
