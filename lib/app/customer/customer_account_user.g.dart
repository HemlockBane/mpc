// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_account_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerAccountUsers _$CustomerAccountUsersFromJson(Map<String, dynamic> json) {
  return CustomerAccountUsers(
    id: json['id'] as int,
    customerAccount: json['customerAccount'] == null
        ? null
        : CustomerAccount.fromJson(json['customerAccount'] as Object),
    permittedFeatures: (json['permittedFeatures'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    featureOverride: json['featureOverride'] as bool?,
    role: json['role'] as String?,
    authenticationType: json['authenticationType'] as String?,
    authorities: (json['authorities'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    featureGroups: (json['featureGroups'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$CustomerAccountUsersToJson(
        CustomerAccountUsers instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerAccount': instance.customerAccount,
      'permittedFeatures': instance.permittedFeatures,
      'featureOverride': instance.featureOverride,
      'role': instance.role,
      'authenticationType': instance.authenticationType,
      'authorities': instance.authorities,
      'featureGroups': instance.featureGroups,
    };
