// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_profile_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountProfile _$AccountProfileFromJson(Map<String, dynamic> json) {
  return AccountProfile()
    ..transactionReference = json['transactionReference'] as String?
    ..accountNumber = json['accountNumber'] as String?
    ..accountName = json['accountName'] as String?
    ..customerId = json['customerId'] as String?
    ..meta = json['meta'] as String?;
}

Map<String, dynamic> _$AccountProfileToJson(AccountProfile instance) =>
    <String, dynamic>{
      'transactionReference': instance.transactionReference,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
      'customerId': instance.customerId,
      'meta': instance.meta,
    };
