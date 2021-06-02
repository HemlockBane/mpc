// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillTransaction _$BillTransactionFromJson(Map<String, dynamic> json) {
  return BillTransaction(
    batchId: json['batch_id'] as int,
    historyId: json['history_id'] as int?,
    bill: json['bill'] == null
        ? null
        : BillHistoryItem.fromJson(json['bill'] as Object),
    batchStatus: json['status'] as String?,
    username: json['username'] as String?,
    institutionBill: json['institutionBill'] == null
        ? null
        : TransactionBatch.fromJson(json['institutionBill'] as Object),
    historyType: json['historyType'] as String?,
    creationTimeStamp: json['creationTimeStamp'] as int?,
  );
}

Map<String, dynamic> _$BillTransactionToJson(BillTransaction instance) =>
    <String, dynamic>{
      'username': instance.username,
      'batch_id': instance.batchId,
      'history_id': instance.historyId,
      'institutionBill': instance.institutionBill,
      'bill': instance.bill,
      'historyType': instance.historyType,
      'creationTimeStamp': instance.creationTimeStamp,
      'status': instance.batchStatus,
    };
