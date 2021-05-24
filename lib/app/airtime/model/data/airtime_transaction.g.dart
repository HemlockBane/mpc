// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirtimeTransaction _$AirtimeTransactionFromJson(Map<String, dynamic> json) {
  return AirtimeTransaction()
    ..username = json['username'] as String?
    ..institutionAirtime =
        TransactionBatch.fromJson(json['institutionAirtime'] as Object)
    ..request = AirtimeHistoryItem.fromJson(json['request'] as Object)
    ..historyType = json['historyType'] as String?;
}

Map<String, dynamic> _$AirtimeTransactionToJson(AirtimeTransaction instance) =>
    <String, dynamic>{
      'username': instance.username,
      'institutionAirtime': instance.institutionAirtime,
      'request': instance.request,
      'historyType': instance.historyType,
    };
