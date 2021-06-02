// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_transfer_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleTransferTransaction _$SingleTransferTransactionFromJson(
    Map<String, dynamic> json) {
  return SingleTransferTransaction(
    batchId: json['batch_id'] as int?,
    historyId: json['history_id'] as int?,
    transferBatch: json['transferBatch'] == null
        ? null
        : TransferBatch.fromJson(json['transferBatch'] as Object),
    transfer: json['transfer'] == null
        ? null
        : TransferHistoryItem.fromJson(json['transfer'] as Object),
    historyType: json['historyType'] as String?,
    historyDateAdded: json['dateAdded'] as int?,
  );
}

Map<String, dynamic> _$SingleTransferTransactionToJson(
        SingleTransferTransaction instance) =>
    <String, dynamic>{
      'batch_id': instance.batchId,
      'history_id': instance.historyId,
      'transferBatch': instance.transferBatch,
      'transfer': instance.transfer,
      'historyType': instance.historyType,
      'dateAdded': instance.historyDateAdded,
    };
