import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';

part 'flex_account_balance.g.dart';

@JsonSerializable()
class FlexAccountBalance {
  FlexAccountBalance({
    this.savingAccountId,
    this.accountBalance,
  });

  final int? savingAccountId;
  final AccountBalance? accountBalance;

  factory FlexAccountBalance.fromJson(Object? data) => _$FlexAccountBalanceFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FlexAccountBalanceToJson(this);

}