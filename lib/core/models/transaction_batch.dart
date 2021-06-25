import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/transaction_meta_data.dart';

part 'transaction_batch.g.dart';

@JsonSerializable()
class TransactionBatch {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "batchKey")
  String? batchKey;

  @JsonKey(name: "sourceAccountProviderCode")
  String? sourceAccountProviderCode;

  @JsonKey(name: "sourceAccountProviderName")
  String? sourceAccountProviderName;

  @JsonKey(name: "sourceAccountNumber")
  String? sourceAccountNumber;

  @JsonKey(name: "currencyCode")
  String? currencyCode;

  @JsonKey(name: "initiator")
  String? initiator;

  @JsonKey(name: "status")
  String? status;

  @JsonKey(name: "paymentType")
  PaymentType? paymentType;

  @JsonKey(name: "paymentInterval")
  String? paymentInterval;

  @JsonKey(name: "responseCode")
  String? responseCode;

  @JsonKey(name: "comment")
  String? comment;

  @JsonKey(name: "count")
  int? count;

  // @JsonKey(name: "createdOn")
  // @TypeConverters(DateListTypeConverter.class)
  // String? createdOn;

  @JsonKey(name: "minorTotalAmount")
  double? minorTotalAmount;

  @JsonKey(name: "transactionStatus")
  String? transactionStatus;

  @JsonKey(name: "paymentMethod")
  String? paymentMethod;

  // @JsonKey(name: "paymentStartDate")
  // // @TypeConverters(DateListTypeConverter.class)
  // String? paymentStartDate;
  //
  // @JsonKey(name: "nextPaymentDate")
  // // @TypeConverters(DateListTypeConverter.class)
  // String? nextPaymentDate;
  //
  // @JsonKey(name: "paymentEndDate")
  // // @TypeConverters(DateListTypeConverter.class)
  // String? paymentEndDate;

  // @JsonKey(name: "startPayDate")
  // int? startPayDate;
  //
  // @JsonKey(name: "nextPayDate")
  // int? nextPayDate;
  //
  // @JsonKey(name: "endPayDate")
  // int? endPayDate;
  //
  // @JsonKey(name: "creationDate")
  // int? creationDate;

  @JsonKey(name: "transactionName")
  String? transactionName;

  // @JsonKey(name: "completedOn")
  // // @TypeConverters(DateListTypeConverter.class)
  // String? completedOn;

  @JsonKey(name: "tracked")
  bool? tracked;

  @JsonKey(name: "rechargeDate")
  int? rechargeDate;

  @JsonKey(name: "creationTimeStamp")
  int? creationTimeStamp;

  @JsonKey(name:"metaDataObj")
  @TypeConverters([TransactionMetaDataConverter])
  TransactionMetaData? metaData;

  @JsonKey(name: "token")
  String? token;

  TransactionBatch();

//   TransactionBatch({
//     this.id,
//     this.batchKey,
//     this.sourceAccountProviderCode,
//     this.sourceAccountProviderName,
//     this.sourceAccountNumber,
//     this.currencyCode,
//     this.initiator,
//     this.status,
//     this.paymentType,
//     this.paymentInterval,
//     this.responseCode,
//     this.comment,
//     this.count,
//     // this.createdOn,
//     this.minorTotalAmount,
//     this.transactionStatus,
//     this.paymentMethod,
//     // this.paymentStartDate,
//     // this.nextPaymentDate,
//     // this.paymentEndDate,
//     // this.startPayDate,
//     // this.nextPayDate,
//     // this.endPayDate,
//     // this.creationDate,
//     this.transactionName,
//     // this.completedOn,
//     this.tracked,
//     this.rechargeDate,
//     this.creationTimeStamp,
//     this.token,
//     this.metaData
// });

  factory TransactionBatch.fromJson(Object? data) {
    final result = data as Map<String, dynamic>;
    return _$TransactionBatchFromJson(result);
  }
  Map<String, dynamic> toJson() => _$TransactionBatchToJson(this);
}
