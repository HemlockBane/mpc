import 'package:moniepoint_flutter/core/models/transaction_meta_data.dart';

import 'package:json_annotation/json_annotation.dart';

part 'download_transaction_receipt_request_body.g.dart';

@JsonSerializable()
class DownloadTransactionReceiptRequestBody {
  DownloadTransactionReceiptRequestBody({
    this.customerId,
    this.transactionRef,
    this.narration,
    this.metaDataObj,
  });

  int? customerId;
  String? transactionRef;
  String? narration;
  TransactionMetaData? metaDataObj;

  factory DownloadTransactionReceiptRequestBody.fromJson(Object? data) => _$DownloadTransactionReceiptRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$DownloadTransactionReceiptRequestBodyToJson(this);


}