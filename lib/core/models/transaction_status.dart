import 'package:json_annotation/json_annotation.dart';

part 'transaction_status.g.dart';

@JsonSerializable()
class TransactionStatus {

  @JsonKey(name:"workflowStatus")
  final String? workflowStatus;

  @JsonKey(name:"operationStatus")
  final String? operationStatus;

  @JsonKey(name:"token")
  final String? token;

  @JsonKey(name:"transferBatchId")
  final int? transferBatchId;

  @JsonKey(name:"customerAirtimeId")
  final int? customerAirtimeId;

  @JsonKey(name:"customerDataTopUpId")
  final int? customerDataTopUpId;

  @JsonKey(name:"customerBillId")
  final int? customerBillId;

  TransactionStatus({
    this.workflowStatus,
    this.operationStatus,
    this.token,
    this.transferBatchId,
    this.customerAirtimeId,
    this.customerDataTopUpId,
    this.customerBillId
  });

  factory TransactionStatus.fromJson(Object? data) => _$TransactionStatusFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransactionStatusToJson(this);

}