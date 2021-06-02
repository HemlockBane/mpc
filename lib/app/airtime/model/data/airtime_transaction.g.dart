// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirtimeTransaction _$AirtimeTransactionFromJson(Map<String, dynamic> json) {
  return AirtimeTransaction(
    batchId: json['batch_id'] as int,
    historyId: json['history_id'] as int,
    request: json['request'] == null
        ? null
        : AirtimeHistoryItem.fromJson(json['request'] as Object),
    username: json['username'] as String?,
    institutionAirtime: json['institutionAirtime'] == null
        ? null
        : TransactionBatch.fromJson(json['institutionAirtime'] as Object),
    historyType: json['historyType'] as String?,
    creationTimeStamp: json['creationTimeStamp'] as int?,
  );
}

Map<String, dynamic> _$AirtimeTransactionToJson(AirtimeTransaction instance) =>
    <String, dynamic>{
      'username': instance.username,
      'batch_id': instance.batchId,
      'history_id': instance.historyId,
      'institutionAirtime': instance.institutionAirtime,
      'request': instance.request,
      'historyType': instance.historyType,
      'creationTimeStamp': instance.creationTimeStamp,
    };
