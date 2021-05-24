// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_service_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirtimeServiceProvider _$AirtimeServiceProviderFromJson(
    Map<String, dynamic> json) {
  return AirtimeServiceProvider(
    code: json['code'] as String,
    name: json['name'] as String?,
    currencySymbol: json['currencySymbol'] as String?,
    billerId: json['billerId'] as String?,
    identifierName: json['identifierName'] as String?,
    svgImage: json['svgImage'] as String?,
  );
}

Map<String, dynamic> _$AirtimeServiceProviderToJson(
        AirtimeServiceProvider instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'currencySymbol': instance.currencySymbol,
      'billerId': instance.billerId,
      'identifierName': instance.identifierName,
      'svgImage': instance.svgImage,
    };
