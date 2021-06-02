// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirtimeHistoryItem _$AirtimeHistoryItemFromJson(Map<String, dynamic> json) {
  return AirtimeHistoryItem()
    ..transactionBatchId = json['transactionBatchId'] as int?
    ..minorAmount = (json['minorAmount'] as num?)?.toDouble()
    ..status = json['status'] as String?
    ..transactionStatus = json['transactionStatus'] as String?
    ..dateCreated =
        (json['dateCreated'] as List<dynamic>?)?.map((e) => e as int).toList()
    ..channel = json['channel'] as String?
    ..responseCode = json['responseCode'] as String?
    ..comment = json['comment'] as String?
    ..id = json['id'] as int?
    ..serviceProvider = json['serviceProvider'] == null
        ? null
        : AirtimeServiceProvider.fromJson(json['serviceProvider'] as Object)
    ..phoneNumber = json['phoneNumber'] as String?;
}

Map<String, dynamic> _$AirtimeHistoryItemToJson(AirtimeHistoryItem instance) =>
    <String, dynamic>{
      'transactionBatchId': instance.transactionBatchId,
      'minorAmount': instance.minorAmount,
      'status': instance.status,
      'transactionStatus': instance.transactionStatus,
      'dateCreated': instance.dateCreated,
      'channel': instance.channel,
      'responseCode': instance.responseCode,
      'comment': instance.comment,
      'id': instance.id,
      'serviceProvider': instance.serviceProvider,
      'phoneNumber': instance.phoneNumber,
    };
