// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountBalance _$AccountBalanceFromJson(Map<String, dynamic> json) {
  return AccountBalance(
    (json['availableBalance'] as num?)?.toDouble(),
    (json['lienBalance'] as num?)?.toDouble(),
    (json['ledgerBalance'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$AccountBalanceToJson(AccountBalance instance) =>
    <String, dynamic>{
      'availableBalance': instance.availableBalance,
      'lienBalance': instance.lienBalance,
      'ledgerBalance': instance.ledgerBalance,
    };
