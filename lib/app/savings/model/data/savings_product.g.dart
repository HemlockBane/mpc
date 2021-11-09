// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavingsProduct _$SavingsProductFromJson(Map<String, dynamic> json) {
  return SavingsProduct(
    id: json['id'] as int,
    createdOn: stringDateTime(json['createdOn'] as String),
    lastModifiedOn: stringDateTime(json['lastModifiedOn'] as String),
    name: json['name'] as String?,
    shortDescription: json['shortDescription'] as String?,
    longDescription: json['longDescription'] as String?,
    icon: json['icon'] as String?,
    headerImage: json['headerImage'] as String?,
    code: json['code'] as String?,
    cbaSavingsAccountSchemeCode: json['cbaSavingsAccountSchemeCode'] as String?,
    interestRate: (json['interestRate'] as num?)?.toDouble(),
    penalties: json['penalties'] as int?,
    flexSavings: (json['flexSavings'] as List<dynamic>?)
        ?.map((e) => FlexSaving.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SavingsProductToJson(SavingsProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdOn': millisToString(instance.createdOn),
      'lastModifiedOn': millisToString(instance.lastModifiedOn),
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'icon': instance.icon,
      'headerImage': instance.headerImage,
      'code': instance.code,
      'cbaSavingsAccountSchemeCode': instance.cbaSavingsAccountSchemeCode,
      'interestRate': instance.interestRate,
      'penalties': instance.penalties,
      'flexSavings': instance.flexSavings,
    };
