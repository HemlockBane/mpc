// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountProvider _$AccountProviderFromJson(Map<String, dynamic> json) {
  return AccountProvider(
    id: json['id'] as int?,
    name: json['name'] as String?,
    centralBankCode: json['centralBankCode'] as String?,
    aptentRoutingKey: json['aptentRoutingKey'] as String?,
    customerRMNodeType: json['customerRMNodeType'] as String?,
    customerAccountRMNodeType: json['customerAccountRMNodeType'] as String?,
    unsupportedFeatures: (json['unsupportedFeatures'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$AccountProviderToJson(AccountProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'centralBankCode': instance.centralBankCode,
      'aptentRoutingKey': instance.aptentRoutingKey,
      'customerRMNodeType': instance.customerRMNodeType,
      'customerAccountRMNodeType': instance.customerAccountRMNodeType,
      'unsupportedFeatures': instance.unsupportedFeatures,
    };
