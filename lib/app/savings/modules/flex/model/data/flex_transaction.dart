import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_category.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/models/transaction_meta_data.dart';

part 'flex_transaction.g.dart';

const FLEX_TRANSACTION_TABLE = "flex_transactions";

@Entity(tableName: "$FLEX_TRANSACTION_TABLE")
@JsonSerializable()
class FlexTransaction extends Transaction{

  FlexTransaction({
    required this.transactionDate,
    required this.transactionRef,
    this.status,
    this.amount,
    this.accountNumber,
    this.type,
    this.transactionChannel,
    this.tags,
    this.narration,
    this.runningBalance,
    this.balanceBefore,
    this.balanceAfter,
    this.metaData,
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
    this.location,
    this.flexSavingId
  });

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

  @JsonKey(name: "flexSavingId")
  int? flexSavingId;

  factory FlexTransaction.fromJson(Object? data) {
    return _$FlexTransactionFromJson(data as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() => _$FlexTransactionToJson(this);

  @override
  double getAmount() {
    return this.amount ?? 0;
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
    return this.transactionDate;
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
    return this.type ?? TransactionType.CREDIT;
  }

}
