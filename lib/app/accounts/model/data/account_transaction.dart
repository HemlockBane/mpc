
import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_category.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/models/transaction_meta_data.dart';

part 'account_transaction.g.dart';

enum TransactionChannel { ALL, ATM, POS, WEB, USSD, MOBILE }

@Entity(tableName: "account_transactions")
@JsonSerializable()
class AccountTransaction extends Transaction implements ListItem {
  final int? id;

  @JsonKey(name: "accountNumber")
  String? accountNumber;

  @JsonKey(name: "status")
  final bool? status;

  @PrimaryKey()
  @JsonKey(name: "transactionRef")
  final String transactionRef;

  @JsonKey(name: "amount")
  final double? amount;

  @JsonKey(name: "type")
  @TypeConverters([TransactionTypeConverter])
  final TransactionType? type;

  @JsonKey(name: "transactionChannel")
  //@TypeConverters([TransactionChannelConverter])
  final String? transactionChannel;

  @JsonKey(name: "tags")
  final String? tags;

  @JsonKey(name: "narration")
  final String? narration;

  @JsonKey(name: "transactionDate", fromJson: stringDateTime, toJson: millisToString)
  final int transactionDate;

  @JsonKey(name: "runningBalance")
  final String? runningBalance;

  @JsonKey(name: "balanceBefore")
  final String? balanceBefore;

  @JsonKey(name: "balanceAfter")
  final String? balanceAfter;

  @JsonKey(name: "transactionCategory")
  @TypeConverters([TransactionCategoryConverter])
  final TransactionCategory? transactionCategory;

  @JsonKey(name: "transactionCode")
  final String? transactionCode;

  @JsonKey(name: "beneficiaryIdentifier")
  final String? beneficiaryIdentifier;

  @JsonKey(name: "beneficiaryName")
  final String? beneficiaryName;

  @JsonKey(name: "beneficiaryBankName")
  final String? beneficiaryBankName;

  @JsonKey(name: "beneficiaryBankCode")
  final String? beneficiaryBankCode;

  @JsonKey(name: "senderIdentifier")
  final String? senderIdentifier;

  @JsonKey(name: "senderName")
  final String? senderName;

  @JsonKey(name: "senderBankName")
  final String? senderBankName;

  @JsonKey(name: "senderBankCode")
  final String? senderBankCode;

  @JsonKey(name: "providerIdentifier")
  final String? providerIdentifier;

  @JsonKey(name: "providerName")
  final String? providerName;

  @JsonKey(name: "transactionIdentifier")
  final String? transactionIdentifier;

  @JsonKey(name: "merchantLocation")
  final String? merchantLocation;

  @JsonKey(name: "cardScheme")
  final String? cardScheme;

  @JsonKey(name: "maskedPan")
  final String? maskedPan;

  @JsonKey(name: "terminalId")
  final String? terminalID;

  @JsonKey(name: "disputable")
  final bool? disputable;

  @JsonKey(name: "location")
  @TypeConverters([LocationConverter])
  final Location? location;

  @JsonKey(name: "metaDataObj")
  @TypeConverters([TransactionMetaDataConverter])
  final TransactionMetaData? metaData;

  @JsonKey(name: "customerAccountId")
  int? customerAccountId;

  AccountTransaction({
    this.id,
    required this.transactionDate,
    required this.transactionRef,
    this.status,
    this.amount,
    this.type,
    this.transactionChannel,
    this.tags,
    this.narration,
    this.runningBalance,
    this.balanceBefore,
    this.balanceAfter,
    this.metaData,
    this.customerAccountId,
    this.transactionCategory,
    this.transactionCode,
    this.beneficiaryIdentifier,
    this.beneficiaryName,
    this.beneficiaryBankName,
    this.beneficiaryBankCode,
    this.senderIdentifier,
    this.senderName,
    this.senderBankName,
    this.senderBankCode,
    this.providerIdentifier,
    this.providerName,
    this.transactionIdentifier,
    this.merchantLocation,
    this.cardScheme,
    this.maskedPan,
    this.terminalID,
    this.disputable,
    this.location
  });

  factory AccountTransaction.fromJson(Object? data) {
    return _$AccountTransactionFromJson(data as Map<String, dynamic>);
  }

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
    return beneficiaryName ?? "";
  }

  @override
  String getSinkAccountNumber() {
    return beneficiaryIdentifier ?? "";
  }

  @override
  String? getSinkAccountBankCode() {
    return beneficiaryBankCode;
  }

  @override
  String? getSinkAccountBankName() {
    return beneficiaryBankName;
  }

  @override
  String getSourceAccountBank() {
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
    return this.type ?? TransactionType.CREDIT;
  }
}
