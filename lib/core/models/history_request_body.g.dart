// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryRequestBody _$HistoryRequestBodyFromJson(Map<String, dynamic> json) {
  return HistoryRequestBody()
    ..page = json['page'] as int?
    ..pageSize = json['pageSize'] as int?
    ..startDate = json['startDate'] as int?
    ..endDate = json['endDate'] as int?
    ..statuses =
        (json['statuses'] as List<dynamic>?)?.map((e) => e as String).toList();
}

Map<String, dynamic> _$HistoryRequestBodyToJson(HistoryRequestBody instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'statuses': instance.statuses,
    };
