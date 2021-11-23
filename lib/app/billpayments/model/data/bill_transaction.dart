import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bill_transaction.g.dart';

@Entity(tableName: "bill_transactions", primaryKeys: ['id'])
@JsonSerializable()
class BillTransaction extends Transaction {

  final int? id;
  final int? minorAmount;
  final String? sourceAccountProviderName;
  final String? sourceAccountNumber;
  final String? sourceAccountCurrencyCode;
  final String? transactionStatus;
  @JsonKey(name: "transactionTime", fromJson: stringDateTime, toJson: millisToString)
  final int? transactionTime;
  final String? customerId;
  final String? customerIdName;
  final String? billerCategoryName;
  final String? billerCategoryCode;
  final String? billerName;
  final String? billerCode;
  final String? billerLogoUUID;
  final String? billerProductName;
  final String? billerProductCode;
  final String? transactionId;
  final String? token;

  BillTransaction({
    required this.id,
    this.minorAmount,
    this.sourceAccountProviderName,
    this.sourceAccountNumber,
    this.sourceAccountCurrencyCode,
    this.transactionStatus,
    this.transactionTime,
    this.customerId,
    this.customerIdName,
    this.billerCategoryName,
    this.billerCategoryCode,
    this.billerName,
    this.billerCode,
    this.billerLogoUUID,
    this.billerProductName,
    this.billerProductCode,
    this.transactionId,
    this.token,
  });

  factory BillTransaction.fromJson(Object? data) {
    final mapData = data as Map<String, dynamic>;
    final transaction = _$BillTransactionFromJson(mapData);
    return transaction;
  }
  Map<String, dynamic> toJson() => _$BillTransactionToJson(this);


  @override
  double getAmount() {
    return (minorAmount ?? 0) / 100;
  }

  @override
  String getBatchKey() {
    return "";
  }

  @override
  String getComment() {
    return "";
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
    return 0;
  }

  @override
  int getInitiatedDate() {
    return transactionTime ?? 0;
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
    return "";
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
    return sourceAccountNumber ?? "";
  }

  @override
  num getTransactionDate() {
    return transactionTime ?? 0;
  }

  @override
  TransactionType getType() {
    return TransactionType.DEBIT;
  }

}