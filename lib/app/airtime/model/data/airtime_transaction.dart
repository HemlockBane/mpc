import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/models/transaction_batch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'airtime_history_item.dart';

part 'airtime_transaction.g.dart';

@Entity(tableName: "airtime_transactions", primaryKeys: ['batch_id', 'history_id'])
@JsonSerializable()
class AirtimeTransaction implements Transaction {

  String? username = "";

  @ColumnInfo(name : "batch_id")
  @JsonKey(name: "batch_id")
  final int batchId;

  @ColumnInfo(name : "history_id")
  @JsonKey(name: "history_id")
  final int historyId;

  @JsonKey(name:"institutionAirtime")
  @ColumnInfo(name: "batch")
  @TypeConverters([TransactionBatchConverter])
  final TransactionBatch? institutionAirtime;

  @JsonKey(name:"request")
  @ColumnInfo(name: "history")
  @TypeConverters([AirtimeHistoryItemConverter])
  final AirtimeHistoryItem? request;

  final String? historyType;

  @ColumnInfo(name : "creationTimeStamp")
  @JsonKey(name: "creationTimeStamp")
  final int? creationTimeStamp;

  AirtimeTransaction({
    required this.batchId,
    required this.historyId,
    required this.request,
    this.username,
    this.institutionAirtime,
    this.historyType,
    this.creationTimeStamp
  });

  factory AirtimeTransaction.fromJson(Object? data) {
    final mapData = data as Map<String, dynamic>;
    if(mapData["institutionAirtime"] != null){
      mapData["batch_id"] = mapData["institutionAirtime"]["id"];
      mapData["creationTimeStamp"] = mapData["institutionAirtime"]["creationTimeStamp"];
    }
    mapData["history_id"] = mapData["request"]["id"];
    final transaction = _$AirtimeTransactionFromJson(mapData);
    return transaction;
  }
  Map<String, dynamic> toJson() => _$AirtimeTransactionToJson(this);


  @override
  double getAmount() {
    return (request?.minorAmount ?? 0) / 100;
  }

  @override
  String getBatchKey() {
    return institutionAirtime?.batchKey ?? "";
  }

  @override
  String getComment() {
    return institutionAirtime?.transactionName ?? "";
  }

  @override
  String getCurrencyCode() {
    // TODO: implement getCurrencyCode
    throw UnimplementedError();
  }

  @override
  String getDescription() {
    return request?.phoneNumber ?? "";
  }

  @override
  int getId() {
    return institutionAirtime?.id ?? 0;
  }

  @override
  int getInitiatedDate() {
    return 0;
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
    return institutionAirtime?.paymentType ?? PaymentType.ONE_TIME;
  }

  @override
  String getSinkAccountName() {
    return request?.phoneNumber ?? "";
  }

  @override
  String getSinkAccountNumber() {
    return "";
  }

  @override
  String getSourceAccountBank() {
    return "";
  }

  @override
  String getSourceAccountNumber() {
    return institutionAirtime?.sourceAccountNumber ?? "";
  }

  @override
  num getTransactionDate() {
    return institutionAirtime?.creationTimeStamp ?? 0;
  }

  @override
  TransactionType getType() {
    return TransactionType.DEBIT;
  }

}