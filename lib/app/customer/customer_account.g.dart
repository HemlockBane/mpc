// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerAccount _$CustomerAccountFromJson(Map<String, dynamic> json) {
  return CustomerAccount(
    id: json['id'] as int?,
    customer: json['customer'] == null
        ? null
        : Customer.fromJson(json['customer'] as Object),
    cbaCustomerId: json['cbaCustomerId'] as String?,
    bankBranchId: json['bankBranchId'] as int?,
    accountName: json['accountName'] as String?,
    currencyCode: json['currencyCode'] as String?,
    accountNumber: json['accountNumber'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    email: json['email'] as String?,
    address: json['address'] as String?,
    openingDate:
        (json['openingDate'] as List<dynamic>?)?.map((e) => e as int).toList(),
    alternateAccountNumber: json['alternateAccountNumber'] as String?,
    accountType: json['accountType'] as String?,
    bvn: json['bvn'] as String?,
    accountBalance: (json['accountBalance'] as num?)?.toDouble(),
    schemeCode: json['schemeCode'] == null
        ? null
        : SchemeCode.fromJson(json['schemeCode'] as Object),
    validated: json['validated'] as bool?,
    relationshipManagerNodeGuid: json['relationshipManagerNodeGuid'] as String?,
    relationshipManagerUserId: json['relationshipManagerUserId'] as String?,
    active: json['active'] as bool?,
    unsupportedFeatures: (json['unsupportedFeatures'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    multipleDebit: json['multipleDebit'] as bool?,
  );
}

Map<String, dynamic> _$CustomerAccountToJson(CustomerAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'cbaCustomerId': instance.cbaCustomerId,
      'bankBranchId': instance.bankBranchId,
      'accountName': instance.accountName,
      'currencyCode': instance.currencyCode,
      'accountNumber': instance.accountNumber,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'openingDate': instance.openingDate,
      'alternateAccountNumber': instance.alternateAccountNumber,
      'accountType': instance.accountType,
      'bvn': instance.bvn,
      'accountBalance': instance.accountBalance,
      'schemeCode': instance.schemeCode,
      'validated': instance.validated,
      'relationshipManagerNodeGuid': instance.relationshipManagerNodeGuid,
      'relationshipManagerUserId': instance.relationshipManagerUserId,
      'active': instance.active,
      'unsupportedFeatures': instance.unsupportedFeatures,
      'multipleDebit': instance.multipleDebit,
    };
