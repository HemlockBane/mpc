import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/models/transaction_meta_data.dart';

part 'account_transaction.g.dart';

enum  TransactionChannel {
  ATM,POS, WEB, USSD, MOBILE, KIOSK
}


@Entity(tableName: "account_transactions")
@JsonSerializable()
class AccountTransaction implements ListItem, Transaction {

  final int? id;

  @JsonKey(name:"accountNumber")
  final String? accountNumber = "NULL";

  @JsonKey(name:"status")
  final bool? status;

  @PrimaryKey()
  @JsonKey(name:"transactionRef")
  final String transactionRef;

  @JsonKey(name:"amount")
  final double? amount;

  @JsonKey(name:"type")
  @TypeConverters([TransactionTypeConverter])
  final TransactionType? type;

  @JsonKey(name:"channel")
  final String? channel;

  @JsonKey(name:"transactionChannel")
  //@TypeConverters([TransactionChannelConverter])
  final String? transactionChannel;

  @JsonKey(name:"tags")
  final String? tags;

  @JsonKey(name:"narration")
  final String? narration;

  @JsonKey(name:"transactionDate", fromJson: stringDateTime)
  final int transactionDate;

  @JsonKey(name:"runningBalance")
  final String? runningBalance;

  @JsonKey(name:"balanceBefore")
  final String? balanceBefore;

  @JsonKey(name:"balanceAfter")
  final String? balanceAfter;

  @JsonKey(name:"metaDataObj")
  @TypeConverters([TransactionMetaDataConverter])
  final TransactionMetaData? metaData;

  @JsonKey(name:"customerAccountId")
  int? customerAccountId;

  AccountTransaction(
      {this.id,
      required this.transactionDate,
      required this.transactionRef,
      this.status,
      this.amount,
      this.type,
      this.channel,
      this.transactionChannel,
      this.tags,
      this.narration,
      this.runningBalance,
      this.balanceBefore,
      this.balanceAfter,
      this.metaData,
      this.customerAccountId
      });

  factory AccountTransaction.fromJson(Object? data) => _$AccountTransactionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccountTransactionToJson(this);


  String getTransactionChannelValue() {
    final channel = this.transactionChannel;
    return channel == null ? "" : channel;
  }

  @override
  double getAmount() {
    return this.amount ?? 0;
  }

  @override
  String getBatchKey() {
    return this.transactionRef;
  }

  @override
  String getComment() {
    // TODO: implement getComment
    return "";
  }

  @override
  String getCurrencyCode() {
    return "";
  }

  @override
  String getDescription() {
    // TODO: implement getDescription
    return "";
  }

  @override
  int getId() {
    // TODO: implement getId
    return this.id ?? 0;
  }

  @override
  int getInitiatedDate() {
    // TODO: implement getInitiatedDate
    return this.transactionDate;
  }

  @override
  String getInitiatorName() {
    // TODO: implement getInitiatorName
    return "";
  }

  @override
  int getListItemType() {
    // TODO: implement getListItemType
    return ListItem.TYPE_GENERAL;
  }

  @override
  num getNextPayDate() {
    // TODO: implement getNextPayDate
    return 0;
  }

  @override
  String getPaymentInterval() {
    // TODO: implement getPaymentInterval
    return "";
  }

  @override
  PaymentType getPaymentType() {
    // TODO: implement getPaymentType
    return PaymentType.ONE_TIME;
  }

  @override
  String getSinkAccountName() {
    // TODO: implement getSinkAccountName
    return "";
  }

  @override
  String getSinkAccountNumber() {
    // TODO: implement getSinkAccountNumber
    return "";
  }

  @override
  String getSourceAccountBank() {
    // TODO: implement getSourceAccountBank
    return "";
  }

  @override
  String getSourceAccountNumber() {
    // TODO: implement getSourceAccountNumber
    return "";
  }

  @override
  num getTransactionDate() {
    return 00;
  }

  @override
  TransactionType getType() {
    return this.type ??  TransactionType.CREDIT;
  }

}