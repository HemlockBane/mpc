// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_statement_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportStatementRequestBody _$ExportStatementRequestBodyFromJson(
    Map<String, dynamic> json) {
  return ExportStatementRequestBody(
    customerAccountId: json['customerAccountId'] as int?,
    fileType: json['fileType'] as String?,
    transactionType: json['transactionType'] as String?,
    startDate: json['startDate'] as int?,
    endDate: json['endDate'] as int?,
  );
}

Map<String, dynamic> _$ExportStatementRequestBodyToJson(
        ExportStatementRequestBody instance) =>
    <String, dynamic>{
      'customerAccountId': instance.customerAccountId,
      'fileType': instance.fileType,
      'transactionType': instance.transactionType,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
