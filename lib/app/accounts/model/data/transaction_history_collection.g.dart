// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionHistoryCollection _$TransactionHistoryCollectionFromJson(
    Map<String, dynamic> json) {
  return TransactionHistoryCollection()
    ..content = (json['content'] as List<dynamic>?)
        ?.map((e) => AccountTransaction.fromJson(e as Object))
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

Map<String, dynamic> _$TransactionHistoryCollectionToJson(
        TransactionHistoryCollection instance) =>
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
