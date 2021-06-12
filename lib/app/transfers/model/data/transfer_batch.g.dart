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
  );
}

Map<String, dynamic> _$TransferBatchToJson(TransferBatch instance) =>
    <String, dynamic>{
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
