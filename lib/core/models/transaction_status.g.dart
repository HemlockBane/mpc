// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionStatus _$TransactionStatusFromJson(Map<String, dynamic> json) {
  return TransactionStatus(
    workflowStatus: json['workflowStatus'] as String?,
    operationStatus: json['operationStatus'] as String?,
    token: json['token'] as String?,
    transferBatchId: json['transferBatchId'] as int?,
    customerAirtimeId: json['customerAirtimeId'] as int?,
    customerDataTopUpId: json['customerDataTopUpId'] as int?,
    customerBillId: json['customerBillId'] as int?,
    message: json['message'] as String?,
  );
}

Map<String, dynamic> _$TransactionStatusToJson(TransactionStatus instance) =>
    <String, dynamic>{
      'workflowStatus': instance.workflowStatus,
      'operationStatus': instance.operationStatus,
      'token': instance.token,
      'transferBatchId': instance.transferBatchId,
      'customerAirtimeId': instance.customerAirtimeId,
      'customerDataTopUpId': instance.customerDataTopUpId,
      'customerBillId': instance.customerBillId,
      'message': instance.message,
    };
