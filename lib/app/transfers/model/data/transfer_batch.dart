import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/transaction_batch.dart';

part 'transfer_batch.g.dart';

@JsonSerializable()
class TransferBatch extends TransactionBatch {

  @JsonKey(name: "parentTransferBatch")
  @ignore
  final Object? parentTransferBatch;

  @JsonKey(name: "clientId")
  final String? clientId;

  @JsonKey(name: "narration")
  final String? narration;

  @JsonKey(name: "transferType")
  final String? transferType;

  @JsonKey(name: "transferMethod")
  @ColumnInfo(name: "transferMethod")
  final String? paymentMethod;

  @JsonKey(name: "transactionCount")
  @ColumnInfo(name: "transactionCount")
  final int? count;

  @JsonKey(name: "totalMinorAmount")
  @ColumnInfo(name: "totalMinorAmount")
  final double? minorTotalAmount;

  @JsonKey(name: "totalMinorFeeAmount")
  final double? totalMinorFeeAmount;

  @JsonKey(name: "totalMinorVatAmount")
  final double? totalMinorVatAmount;

  @JsonKey(name: "authorizedOn")
  final String? authorizedOn;

  @JsonKey(name: "aptentBatchKey")
  final String? aptentBatchKey;

  TransferBatch({
    this.parentTransferBatch,
    this.clientId,
    this.narration,
    this.transferType,
    this.paymentMethod,
    this.count,
    this.minorTotalAmount,
    this.totalMinorFeeAmount,
    this.totalMinorVatAmount,
    this.authorizedOn,
    this.aptentBatchKey
});

  factory TransferBatch.fromJson(Object? data) => _$TransferBatchFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransferBatchToJson(this);
}
