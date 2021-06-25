// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferBatch _$TransferBatchFromJson(Map<String, dynamic> json) {
  return TransferBatch(
    parentTransferBatch: json['parentTransferBatch'],
    clientId: json['clientId'] as String?,
    narration: json['narration'] as String?,
    transferType: json['transferType'] as String?,
    paymentMethod: json['transferMethod'] as String?,
    count: json['transactionCount'] as int?,
    minorTotalAmount: (json['totalMinorAmount'] as num?)?.toDouble(),
    totalMinorFeeAmount: (json['totalMinorFeeAmount'] as num?)?.toDouble(),
    totalMinorVatAmount: (json['totalMinorVatAmount'] as num?)?.toDouble(),
    authorizedOn: json['authorizedOn'] as String?,
    aptentBatchKey: json['aptentBatchKey'] as String?,
  )
    ..id = json['id'] as int?
    ..batchKey = json['batchKey'] as String?
    ..sourceAccountProviderCode = json['sourceAccountProviderCode'] as String?
    ..sourceAccountProviderName = json['sourceAccountProviderName'] as String?
    ..sourceAccountNumber = json['sourceAccountNumber'] as String?
    ..currencyCode = json['currencyCode'] as String?
    ..initiator = json['initiator'] as String?
    ..status = json['status'] as String?
    ..paymentType =
        _$enumDecodeNullable(_$PaymentTypeEnumMap, json['paymentType'])
    ..paymentInterval = json['paymentInterval'] as String?
    ..responseCode = json['responseCode'] as String?
    ..comment = json['comment'] as String?
    ..transactionStatus = json['transactionStatus'] as String?
    ..transactionName = json['transactionName'] as String?
    ..tracked = json['tracked'] as bool?
    ..rechargeDate = json['rechargeDate'] as int?
    ..creationTimeStamp = json['creationTimeStamp'] as int?
    ..metaData = json['metaDataObj'] == null
        ? null
        : TransactionMetaData.fromJson(json['metaDataObj'] as Object)
    ..token = json['token'] as String?;
}

Map<String, dynamic> _$TransferBatchToJson(TransferBatch instance) =>
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
      'transactionStatus': instance.transactionStatus,
      'transactionName': instance.transactionName,
      'tracked': instance.tracked,
      'rechargeDate': instance.rechargeDate,
      'creationTimeStamp': instance.creationTimeStamp,
      'metaDataObj': instance.metaData,
      'token': instance.token,
      'parentTransferBatch': instance.parentTransferBatch,
      'clientId': instance.clientId,
      'narration': instance.narration,
      'transferType': instance.transferType,
      'transferMethod': instance.paymentMethod,
      'transactionCount': instance.count,
      'totalMinorAmount': instance.minorTotalAmount,
      'totalMinorFeeAmount': instance.totalMinorFeeAmount,
      'totalMinorVatAmount': instance.totalMinorVatAmount,
      'authorizedOn': instance.authorizedOn,
      'aptentBatchKey': instance.aptentBatchKey,
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
