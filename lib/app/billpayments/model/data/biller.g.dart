// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Biller _$BillerFromJson(Map<String, dynamic> json) {
  return Biller(
    billerCategoryId: json['billerCategoryName'] as String?,
    billerCategoryCode: json['billerCategoryCode'] as String?,
    id: json['id'] as int,
    name: json['name'] as String?,
    code: json['code'] as String?,
    identifierName: json['identifierName'] as String?,
    currencySymbol: json['currencySymbol'] as String?,
    active: json['active'] as bool?,
    collectionAccountNumber: json['collectionAccountNumber'] as String?,
    collectionAccountName: json['collectionAccountName'] as String?,
    collectionAccountProviderCode:
        json['collectionAccountProviderCode'] as String?,
    collectionAccountProviderName:
        json['collectionAccountProviderName'] as String?,
    svgImage: json['svgImage'] as String?,
  );
}

Map<String, dynamic> _$BillerToJson(Biller instance) => <String, dynamic>{
      'billerCategoryName': instance.billerCategoryId,
      'billerCategoryCode': instance.billerCategoryCode,
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'identifierName': instance.identifierName,
      'currencySymbol': instance.currencySymbol,
      'active': instance.active,
      'collectionAccountNumber': instance.collectionAccountNumber,
      'collectionAccountName': instance.collectionAccountName,
      'collectionAccountProviderCode': instance.collectionAccountProviderCode,
      'collectionAccountProviderName': instance.collectionAccountProviderName,
      'svgImage': instance.svgImage,
    };
