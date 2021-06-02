// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_history_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillHistoryCollection _$BillHistoryCollectionFromJson(
    Map<String, dynamic> json) {
  return BillHistoryCollection()
    ..content = (json['content'] as List<dynamic>?)
        ?.map((e) => BillTransaction.fromJson(e as Object))
        .toList()
    ..totalElements = json['totalElements'] as int?
    ..totalPages = json['totalPages'] as int?
    ..last = json['last'] as bool?
    ..size = json['size'] as int?
    ..number = json['number'] as int?
    ..sort = json['sort']
    ..first = json['first'] as bool?
    ..numberOfElements = json['numberOfElements'] as int?;
}

Map<String, dynamic> _$BillHistoryCollectionToJson(
        BillHistoryCollection instance) =>
    <String, dynamic>{
      'content': instance.content,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
      'size': instance.size,
      'number': instance.number,
      'sort': instance.sort,
      'first': instance.first,
      'numberOfElements': instance.numberOfElements,
    };
