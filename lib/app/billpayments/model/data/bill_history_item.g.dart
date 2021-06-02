// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillHistoryItem _$BillHistoryItemFromJson(Map<String, dynamic> json) {
  return BillHistoryItem()
    ..id = json['id'] as int?
    ..transactionBatchId = json['transactionBatchId'] as int?
    ..minorAmount = (json['minorAmount'] as num?)?.toDouble()
    ..status = json['status'] as String?
    ..transactionStatus = json['transactionStatus'] as String?
    ..dateCreated =
        (json['dateCreated'] as List<dynamic>?)?.map((e) => e as int).toList()
    ..channel = json['channel'] as String?
    ..responseCode = json['responseCode'] as String?
    ..comment = json['comment'] as String?
    ..billProduct = json['billerProduct'] == null
        ? null
        : BillerProduct.fromJson(json['billerProduct'] as Object)
    ..identifier = json['identifier'] as String?;
}

Map<String, dynamic> _$BillHistoryItemToJson(BillHistoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionBatchId': instance.transactionBatchId,
      'minorAmount': instance.minorAmount,
      'status': instance.status,
      'transactionStatus': instance.transactionStatus,
      'dateCreated': instance.dateCreated,
      'channel': instance.channel,
      'responseCode': instance.responseCode,
      'comment': instance.comment,
      'billerProduct': instance.billProduct,
      'identifier': instance.identifier,
    };
