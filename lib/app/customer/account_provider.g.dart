// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountProvider _$AccountProviderFromJson(Map<String, dynamic> json) {
  return AccountProvider(
    id: json['id'] as int?,
    name: json['name'] as String?,
    bankCode: json['bankCode'] as String?,
    bankShortName: json['bankShortName'] as String?,
    centralBankCode: json['centralBankCode'] as String?,
    aptentRoutingKey: json['aptentRoutingKey'] as String?,
    customerRMNodeType: json['customerRMNodeType'] as String?,
    customerAccountRMNodeType: json['customerAccountRMNodeType'] as String?,
    unsupportedFeatures: (json['unsupportedFeatures'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    categoryId: json['categoryId'] as String?,
  )..isSelected = json['isSelected'] as bool?;
}

Map<String, dynamic> _$AccountProviderToJson(AccountProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bankCode': instance.bankCode,
      'bankShortName': instance.bankShortName,
      'centralBankCode': instance.centralBankCode,
      'aptentRoutingKey': instance.aptentRoutingKey,
      'customerRMNodeType': instance.customerRMNodeType,
      'customerAccountRMNodeType': instance.customerAccountRMNodeType,
      'unsupportedFeatures': instance.unsupportedFeatures,
      'categoryId': instance.categoryId,
      'isSelected': instance.isSelected,
    };
