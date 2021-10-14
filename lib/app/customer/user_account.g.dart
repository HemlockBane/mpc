// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccount _$UserAccountFromJson(Map<String, dynamic> json) {
  return UserAccount(
    id: json['id'] as int?,
    customerAccount: json['account'] == null
        ? null
        : CustomerAccount.fromJson(json['account'] as Object),
    accountProvider: json['accountProvider'] == null
        ? null
        : AccountProvider.fromJson(json['accountProvider'] as Object),
    accountBalance: json['accountBalance'] == null
        ? null
        : AccountBalance.fromJson(json['accountBalance'] as Object),
    customer: json['customer'] == null
        ? null
        : Customer.fromJson(json['customer'] as Object),
  )..accountStatus = json['accountStatus'] == null
      ? null
      : AccountStatus.fromJson(json['accountStatus'] as Object);
}

Map<String, dynamic> _$UserAccountToJson(UserAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account': instance.customerAccount,
      'accountProvider': instance.accountProvider,
      'accountBalance': instance.accountBalance,
      'customer': instance.customer,
      'accountStatus': instance.accountStatus,
    };
