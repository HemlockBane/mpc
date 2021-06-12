import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_history_item.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/models/transaction_batch.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bill_transaction.g.dart';

@Entity(tableName: "bill_transactions", primaryKeys: ['batch_id', 'history_id'])
@JsonSerializable()
class BillTransaction implements Transaction {

  String? username = "";

  @ColumnInfo(name : "batch_id")
  @JsonKey(name: "batch_id")
  final int batchId;

  @ColumnInfo(name : "history_id")
  @JsonKey(name: "history_id")
  final int? historyId;

  @JsonKey(name:"institutionBill")
  @ColumnInfo(name: "batch")
  @TypeConverters([TransactionBatchConverter])
  final TransactionBatch? institutionBill;

  @JsonKey(name:"bill")
  @ColumnInfo(name: "history")
  @TypeConverters([BillHistoryItemConverter])
  final BillHistoryItem? bill;

  final String? historyType;

  @ColumnInfo(name : "creationTimeStamp")
  @JsonKey(name: "creationTimeStamp")
  final int? creationTimeStamp;

  @ColumnInfo(name : "batch_status")
  @JsonKey(name: "status")
  final String? batchStatus;

  BillTransaction({
    required this.batchId,
    required this.historyId,
    required this.bill,
    this.batchStatus,
    this.username,
    this.institutionBill,
    this.historyType,
    this.creationTimeStamp
  });

  factory BillTransaction.fromJson(Object? data) {
    final mapData = data as Map<String, dynamic>;
    mapData["batch_id"] = mapData["institutionBill"]["id"];
    mapData["status"] = mapData["institutionBill"]["status"];
    mapData["history_id"] = mapData["bill"]["id"];
    mapData["creationTimeStamp"] = mapData["institutionBill"]["creationTimeStamp"];
    final transaction = _$BillTransactionFromJson(mapData);
    return transaction;
  }
  Map<String, dynamic> toJson() => _$BillTransactionToJson(this);


  @override
  double getAmount() {
    return (bill?.minorAmount ?? 0) / 100;
  }

  @override
  String getBatchKey() {
    return institutionBill?.batchKey ?? "";
  }

  @override
  String getComment() {
    return institutionBill?.transactionName ?? "";
  }

  @override
  String getCurrencyCode() {
    // TODO: implement getCurrencyCode
    throw UnimplementedError();
  }

  @override
  String getDescription() {
    return bill?.getRecipient() ?? "";
  }

  @override
  int getId() {
    return institutionBill?.id ?? 0;
  }

  @override
  int getInitiatedDate() {
    return creationTimeStamp ?? 0;
  }

  @override
  String getInitiatorName() {
    return "";
  }

  @override
  int getListItemType() {
    return ListItem.TYPE_GENERAL;
  }

  @override
  num getNextPayDate() {
    // TODO: implement getNextPayDate
    throw UnimplementedError();
  }

  @override
  String getPaymentInterval() {
    // TODO: implement getPaymentInterval
    throw UnimplementedError();
  }

  @override
  PaymentType getPaymentType() {
    return PaymentType.ONE_TIME;
  }

  @override
  String getSinkAccountName() {
    return bill?.identifier ?? "";
  }

  @override
  String getSinkAccountNumber() {
    return bill?.identifier ?? "";
  }

  @override
  String getSourceAccountBank() {
    return "";
  }

  @override
  String getSourceAccountNumber() {
    return institutionBill?.sourceAccountNumber ?? "";
  }

  @override
  num getTransactionDate() {
    return institutionBill?.creationTimeStamp ?? 0;
  }

  @override
  TransactionType getType() {
    return TransactionType.DEBIT;
  }

}