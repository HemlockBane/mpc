
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';

part 'total_savings_balance.g.dart';

@JsonSerializable()
class TotalSavingsBalance {

  TotalSavingsBalance({
    this.totalSavingBalance,
    this.totalFlexSavingBalance,
    this.flexSavingBalanceList,
  });

  final double? totalSavingBalance;
  final double? totalFlexSavingBalance;
  final List<FlexSavingBalanceList>? flexSavingBalanceList;

  factory TotalSavingsBalance.fromJson(Map<String, dynamic> json) => _$TotalSavingsBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$TotalSavingsBalanceToJson(this);

}

@JsonSerializable()
class FlexSavingBalanceList {

  FlexSavingBalanceList({
    this.savingAccountId,
    this.accountBalance,
  });

  final int? savingAccountId;
  final AccountBalance? accountBalance;

  factory FlexSavingBalanceList.fromJson(Map<String, dynamic> json) => _$FlexSavingBalanceListFromJson(json);
  Map<String, dynamic> toJson() => _$FlexSavingBalanceListToJson(this);

}
