// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavingsProduct _$SavingsProductFromJson(Map<String, dynamic> json) {
  return SavingsProduct(
    id: json['flexSavingProductId'] as int,
    createdOn: stringDateTime(json['createdOn'] as String?),
    lastModifiedOn: stringDateTime(json['lastModifiedOn'] as String?),
    name: json['name'] as String?,
    shortDescription: json['shortDescription'] as String?,
    longDescription: json['longDescription'] as String?,
    icon: json['icon'] as String?,
    headerImage: json['headerImage'] as String?,
    code: json['code'] as String?,
    cbaSavingsAccountSchemeCode: json['cbaSavingsAccountSchemeCode'] as String?,
    flexSavingScheme: json['flexSavingScheme'] == null
        ? null
        : FlexSavingScheme.fromJson(
            json['flexSavingScheme'] as Map<String, dynamic>),
    penalties: json['penalties'] as int?,
    flexSavings: (json['flexSavings'] as List<dynamic>?)
        ?.map((e) => FlexSaving.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SavingsProductToJson(SavingsProduct instance) =>
    <String, dynamic>{
      'flexSavingProductId': instance.id,
      'createdOn': millisToString(instance.createdOn),
      'lastModifiedOn': millisToString(instance.lastModifiedOn),
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'icon': instance.icon,
      'headerImage': instance.headerImage,
      'code': instance.code,
      'cbaSavingsAccountSchemeCode': instance.cbaSavingsAccountSchemeCode,
      'flexSavingScheme': instance.flexSavingScheme,
      'penalties': instance.penalties,
      'flexSavings': instance.flexSavings,
    };
