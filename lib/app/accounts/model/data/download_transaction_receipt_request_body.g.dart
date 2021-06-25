// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_transaction_receipt_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadTransactionReceiptRequestBody
    _$DownloadTransactionReceiptRequestBodyFromJson(Map<String, dynamic> json) {
  return DownloadTransactionReceiptRequestBody(
    customerId: json['customerId'] as int?,
    transactionRef: json['transactionRef'] as String?,
    narration: json['narration'] as String?,
    metaDataObj: json['metaDataObj'] == null
        ? null
        : TransactionMetaData.fromJson(json['metaDataObj'] as Object),
  );
}

Map<String, dynamic> _$DownloadTransactionReceiptRequestBodyToJson(
        DownloadTransactionReceiptRequestBody instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'transactionRef': instance.transactionRef,
      'narration': instance.narration,
      'metaDataObj': instance.metaDataObj,
    };
