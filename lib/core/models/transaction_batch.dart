import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';

part 'transaction_batch.g.dart';

@JsonSerializable()
class TransactionBatch {
  @JsonKey(name: "id")
  final int? id;

  @JsonKey(name: "batchKey")
  final String? batchKey;

  @JsonKey(name: "sourceAccountProviderCode")
  final String? sourceAccountProviderCode;

  @JsonKey(name: "sourceAccountProviderName")
  final String? sourceAccountProviderName;

  @JsonKey(name: "sourceAccountNumber")
  final String? sourceAccountNumber;

  @JsonKey(name: "currencyCode")
  final String? currencyCode;

  @JsonKey(name: "initiator")
  final String? initiator;

  @JsonKey(name: "status")
  final String? status;

  @JsonKey(name: "paymentType")
  final PaymentType? paymentType;

  @JsonKey(name: "paymentInterval")
  final String? paymentInterval;

  @JsonKey(name: "responseCode")
  final String? responseCode;

  @JsonKey(name: "comment")
  final String? comment;

  @JsonKey(name: "count")
  final int? count;

  @JsonKey(name: "createdOn")
  // @TypeConverters(DateListTypeConverter.class)
  final List<int>? createdOn;

  @JsonKey(name: "minorTotalAmount")
  final double? minorTotalAmount;

  @JsonKey(name: "transactionStatus")
  final String? transactionStatus;

  @JsonKey(name: "paymentMethod")
  final String? paymentMethod;

  @JsonKey(name: "paymentStartDate")
  // @TypeConverters(DateListTypeConverter.class)
  final List<int>? paymentStartDate;

  @JsonKey(name: "nextPaymentDate")
  // @TypeConverters(DateListTypeConverter.class)
  final List<int>? nextPaymentDate;

  @JsonKey(name: "paymentEndDate")
  // @TypeConverters(DateListTypeConverter.class)
  final List<int>? paymentEndDate;

  @JsonKey(name: "startPayDate")
  final int? startPayDate;

  @JsonKey(name: "nextPayDate")
  final int? nextPayDate;

  @JsonKey(name: "endPayDate")
  final int? endPayDate;

  @JsonKey(name: "creationDate")
  final int? creationDate;

  @JsonKey(name: "transactionName")
  final String? transactionName;

  @JsonKey(name: "completedOn")
  // @TypeConverters(DateListTypeConverter.class)
  final List<int>? completedOn;

  @JsonKey(name: "tracked")
  final bool? tracked;

  @JsonKey(name: "rechargeDate")
  final String? rechargeDate;

  @JsonKey(name: "creationTimeStamp")
  final int? creationTimeStamp;

  // @JsonKey(name:"metaDataObj")
  // @Embedded(prefix = "_metaData")
  // final MetaData metaData;

  @JsonKey(name: "token")
  final String? token;

  TransactionBatch({
    this.id,
    this.batchKey,
    this.sourceAccountProviderCode,
    this.sourceAccountProviderName,
    this.sourceAccountNumber,
    this.currencyCode,
    this.initiator,
    this.status,
    this.paymentType,
    this.paymentInterval,
    this.responseCode,
    this.comment,
    this.count,
    this.createdOn,
    this.minorTotalAmount,
    this.transactionStatus,
    this.paymentMethod,
    this.paymentStartDate,
    this.nextPaymentDate,
    this.paymentEndDate,
    this.startPayDate,
    this.nextPayDate,
    this.endPayDate,
    this.creationDate,
    this.transactionName,
    this.completedOn,
    this.tracked,
    this.rechargeDate,
    this.creationTimeStamp,
    this.token
});

  factory TransactionBatch.fromJson(Object? data) => _$TransactionBatchFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransactionBatchToJson(this);
}
