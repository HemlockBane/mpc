import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_batch.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:json_annotation/json_annotation.dart';
import 'transfer_history_item.dart';

part 'single_transfer_transaction.g.dart';

@Entity(tableName: "transfer_transactions", primaryKeys: ['batch_id', "history_id"])
@JsonSerializable()
class SingleTransferTransaction extends Transaction {

  @ColumnInfo(name : "batch_id")
  @JsonKey(name: "batch_id")
  final int? batchId;

  @ColumnInfo(name : "history_id")
  @JsonKey(name: "history_id")
  final int? historyId;

  @JsonKey(name:"transferBatch")
  @ColumnInfo(name: "batch")
  @TypeConverters([TransferBatchConverter])
  final TransferBatch? transferBatch;

  @JsonKey(name:"transfer")
  @ColumnInfo(name : "history")
  @TypeConverters([TransferHistoryItemConverter])
  final TransferHistoryItem? transfer;

  final String? historyType;

  @ColumnInfo(name : "dateAdded")
  @JsonKey(name: "dateAdded")
  final int? historyDateAdded;

  SingleTransferTransaction({
    this.batchId,
    this.historyId,
    this.transferBatch,
    this.transfer,
    this.historyType,
    this.historyDateAdded
  });

  factory SingleTransferTransaction.fromJson(Object? data) {
    final mapData = data as Map<String, dynamic>;
    mapData["dateAdded"] = mapData["transfer"]["dateAdded"];
    mapData["batch_id"] = mapData["transferBatch"]["id"];
    mapData["history_id"] = mapData["transfer"]["id"];
    final transaction = _$SingleTransferTransactionFromJson(mapData);
    return transaction;
  }

  Map<String, dynamic> toJson() => _$SingleTransferTransactionToJson(this);

  @override
  double getAmount() {
    return (transfer?.minorAmount ?? 0) / 100;
  }

  @override
  String getBatchKey() {
    return transferBatch?.batchKey ?? "";
  }

  @override
  String getComment() {
    return transfer?.narration ?? "";
  }

  @override
  String getCurrencyCode() {
    // TODO: implement getCurrencyCode
    throw UnimplementedError();
  }

  @override
  String getDescription() {
    return "";
  }

  @override
  int getId() {
    return transfer?.id ?? 0;
  }

  @override
  int getInitiatedDate() {
    print(transfer?.dateAdded);
    return transfer?.dateAdded ?? 0;
  }

  @override
  String getInitiatorName() {
    return transferBatch?.initiator ?? "";
  }

  @override
  int getListItemType() {
    return ListItem.TYPE_GENERAL;
  }

  @override
  num getNextPayDate() {
    return  0;
  }

  @override
  String getPaymentInterval() {
    return transferBatch?.paymentInterval ?? "";
  }

  @override
  PaymentType getPaymentType() {
    return transferBatch?.paymentType ?? PaymentType.ONE_TIME;
  }

  @override
  String getSinkAccountName() {
    return transfer?.sinkAccountName ?? "";
  }

  @override
  String getSinkAccountNumber() {
    return transfer?.sinkAccountNumber ?? "";
  }

  @override
  String getSourceAccountBank() {
    return transfer?.sourceAccountProviderName ?? "";
  }

  @override
  String getSourceAccountNumber() {
    return transfer?.sourceAccountNumber ?? "";
  }

  @override
  num getTransactionDate() {
    return transfer?.dateAdded ?? 0;
  }

  @override
  TransactionType getType() {
    return TransactionType.DEBIT;
  }

}