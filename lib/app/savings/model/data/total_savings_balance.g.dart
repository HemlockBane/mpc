// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_savings_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalSavingsBalance _$TotalSavingsBalanceFromJson(Map<String, dynamic> json) {
  return TotalSavingsBalance(
    totalSavingBalance: (json['totalSavingBalance'] as num?)?.toDouble(),
    totalFlexSavingBalance:
        (json['totalFlexSavingBalance'] as num?)?.toDouble(),
    flexSavingBalanceList: (json['flexSavingBalanceList'] as List<dynamic>?)
        ?.map((e) => FlexSavingBalanceList.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TotalSavingsBalanceToJson(
        TotalSavingsBalance instance) =>
    <String, dynamic>{
      'totalSavingBalance': instance.totalSavingBalance,
      'totalFlexSavingBalance': instance.totalFlexSavingBalance,
      'flexSavingBalanceList': instance.flexSavingBalanceList,
    };

FlexSavingBalanceList _$FlexSavingBalanceListFromJson(
    Map<String, dynamic> json) {
  return FlexSavingBalanceList(
    savingAccountId: json['savingAccountId'] as int?,
    accountBalance: json['accountBalance'] == null
        ? null
        : AccountBalance.fromJson(json['accountBalance'] as Object),
  );
}

Map<String, dynamic> _$FlexSavingBalanceListToJson(
        FlexSavingBalanceList instance) =>
    <String, dynamic>{
      'savingAccountId': instance.savingAccountId,
      'accountBalance': instance.accountBalance,
    };
