// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferHistoryItem _$TransferHistoryItemFromJson(Map<String, dynamic> json) {
  return TransferHistoryItem(
    sinkAccountName: json['sinkAccountName'] as String?,
    validatedSinkAccountName: json['validatedSinkAccountName'] as String?,
    nameEnquiryReference: json['nameEnquiryReference'] as String?,
    transactionId: json['transactionId'] as String?,
    sourceAccountProviderCode: json['sourceAccountProviderCode'] as String?,
    sinkAccountProviderCode: json['sinkAccountProviderCode'] as String?,
    sinkAccountProviderName: json['sinkAccountProviderName'] as String?,
    sourceAccountProviderName: json['sourceAccountProviderName'] as String?,
    sourceAccountNumber: json['sourceAccountNumber'] as String?,
    sinkAccountNumber: json['sinkAccountNumber'] as String?,
    minorFeeAmount: (json['minorFeeAmount'] as num?)?.toDouble(),
    minorVatAmount: (json['minorVatAmount'] as num?)?.toDouble(),
    narration: json['narration'] as String?,
    extraInformation: json['extraInformation'] as String?,
    currencyCode: json['currencyCode'] as String?,
    dateCreated: json['timeAdded'] as String?,
    timeExecuted: json['timeExecuted'] as String?,
    transferBatchKey: json['transferBatchKey'] as String?,
    transferType: json['transferType'] as String?,
    dateAdded: json['dateAdded'] as int?,
  )
    ..id = json['id'] as int?
    ..transactionBatchId = json['transactionBatchId'] as int?
    ..minorAmount = (json['minorAmount'] as num?)?.toDouble()
    ..status = json['status'] as String?
    ..transactionStatus = json['transactionStatus'] as String?
    ..channel = json['channel'] as String?
    ..responseCode = json['responseCode'] as String?
    ..comment = json['comment'] as String?;
}

Map<String, dynamic> _$TransferHistoryItemToJson(
        TransferHistoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionBatchId': instance.transactionBatchId,
      'minorAmount': instance.minorAmount,
      'status': instance.status,
      'transactionStatus': instance.transactionStatus,
      'channel': instance.channel,
      'responseCode': instance.responseCode,
      'comment': instance.comment,
      'sinkAccountName': instance.sinkAccountName,
      'validatedSinkAccountName': instance.validatedSinkAccountName,
      'nameEnquiryReference': instance.nameEnquiryReference,
      'transactionId': instance.transactionId,
      'sourceAccountProviderCode': instance.sourceAccountProviderCode,
      'sinkAccountProviderCode': instance.sinkAccountProviderCode,
      'sinkAccountProviderName': instance.sinkAccountProviderName,
      'sourceAccountProviderName': instance.sourceAccountProviderName,
      'sourceAccountNumber': instance.sourceAccountNumber,
      'sinkAccountNumber': instance.sinkAccountNumber,
      'minorFeeAmount': instance.minorFeeAmount,
      'minorVatAmount': instance.minorVatAmount,
      'narration': instance.narration,
      'extraInformation': instance.extraInformation,
      'currencyCode': instance.currencyCode,
      'timeAdded': instance.dateCreated,
      'timeExecuted': instance.timeExecuted,
      'transferBatchKey': instance.transferBatchKey,
      'transferType': instance.transferType,
      'dateAdded': instance.dateAdded,
    };
