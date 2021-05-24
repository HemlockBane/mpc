// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_history_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferHistoryRequestBody _$TransferHistoryRequestBodyFromJson(
    Map<String, dynamic> json) {
  return TransferHistoryRequestBody(
    startDate: json['startDate'] as int?,
    endDate: json['endDate'] as int?,
    page: json['page'] as int,
    pageSize: json['pageSize'] as int,
  );
}

Map<String, dynamic> _$TransferHistoryRequestBodyToJson(
        TransferHistoryRequestBody instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
