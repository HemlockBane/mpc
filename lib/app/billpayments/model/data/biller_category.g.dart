// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biller_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillerCategory _$BillerCategoryFromJson(Map<String, dynamic> json) {
  return BillerCategory(
    id: json['id'] as int,
    name: json['name'] as String?,
    description: json['description'] as String?,
    categoryCode: json['categoryCode'] as String?,
    active: json['active'] as bool?,
    svgImage: json['svgImage'] as String?,
  );
}

Map<String, dynamic> _$BillerCategoryToJson(BillerCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'categoryCode': instance.categoryCode,
      'active': instance.active,
      'svgImage': instance.svgImage,
    };
