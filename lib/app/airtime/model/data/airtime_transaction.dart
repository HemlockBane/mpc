import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/models/transaction_batch.dart';
import 'package:json_annotation/json_annotation.dart';
import 'airtime_history_item.dart';

part 'airtime_transaction.g.dart';

@Entity(tableName: "airtime_transactions", primaryKeys: ['batch_id'])
@JsonSerializable()
class AirtimeTransaction implements Transaction {

  String? username = "";

  @JsonKey(name:"institutionAirtime")
  @ColumnInfo(name: "batch_")
  TransactionBatch institutionAirtime = new TransactionBatch();

  @JsonKey(name:"request")
  @ColumnInfo(name: "history_")
  AirtimeHistoryItem request = new AirtimeHistoryItem();

  String? historyType;

  AirtimeTransaction();

  factory AirtimeTransaction.fromJson(Object? data) => _$AirtimeTransactionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AirtimeTransactionToJson(this);



  @override
  double getAmount() {
    // TODO: implement getAmount
    throw UnimplementedError();
  }

  @override
  String getBatchKey() {
    // TODO: implement getBatchKey
    throw UnimplementedError();
  }

  @override
  String getComment() {
    // TODO: implement getComment
    throw UnimplementedError();
  }

  @override
  String getCurrencyCode() {
    // TODO: implement getCurrencyCode
    throw UnimplementedError();
  }

  @override
  String getDescription() {
    // TODO: implement getDescription
    throw UnimplementedError();
  }

  @override
  int getId() {
    // TODO: implement getId
    throw UnimplementedError();
  }

  @override
  int getInitiatedDate() {
    // TODO: implement getInitiatedDate
    throw UnimplementedError();
  }

  @override
  String getInitiatorName() {
    // TODO: implement getInitiatorName
    throw UnimplementedError();
  }

  @override
  int getListItemType() {
    // TODO: implement getListItemType
    throw UnimplementedError();
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
    // TODO: implement getPaymentType
    throw UnimplementedError();
  }

  @override
  String getSinkAccountName() {
    // TODO: implement getSinkAccountName
    throw UnimplementedError();
  }

  @override
  String getSinkAccountNumber() {
    // TODO: implement getSinkAccountNumber
    throw UnimplementedError();
  }

  @override
  String getSourceAccountBank() {
    // TODO: implement getSourceAccountBank
    throw UnimplementedError();
  }

  @override
  String getSourceAccountNumber() {
    // TODO: implement getSourceAccountNumber
    throw UnimplementedError();
  }

  @override
  num getTransactionDate() {
    // TODO: implement getTransactionDate
    throw UnimplementedError();
  }

  @override
  TransactionType getType() {
    // TODO: implement getType
    throw UnimplementedError();
  }

}