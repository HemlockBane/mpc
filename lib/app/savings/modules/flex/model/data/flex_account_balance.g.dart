// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_account_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexAccountBalance _$FlexAccountBalanceFromJson(Map<String, dynamic> json) {
  return FlexAccountBalance(
    savingAccountId: json['savingAccountId'] as int?,
    accountBalance: json['accountBalance'] == null
        ? null
        : AccountBalance.fromJson(json['accountBalance'] as Object),
  );
}

Map<String, dynamic> _$FlexAccountBalanceToJson(FlexAccountBalance instance) =>
    <String, dynamic>{
      'savingAccountId': instance.savingAccountId,
      'accountBalance': instance.accountBalance,
    };
