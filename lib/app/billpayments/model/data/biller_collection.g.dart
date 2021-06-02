// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biller_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillerCollection _$BillerCollectionFromJson(Map<String, dynamic> json) {
  return BillerCollection()
    ..content = (json['content'] as List<dynamic>?)
        ?.map((e) => Biller.fromJson(e as Object))
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

Map<String, dynamic> _$BillerCollectionToJson(BillerCollection instance) =>
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
