import 'package:json_annotation/json_annotation.dart';

part 'account_balance.g.dart';

@JsonSerializable()
class AccountBalance {

  @JsonKey(name:"availableBalance")
  final double? availableBalance;
  @JsonKey(name:"lienBalance")
  final double? lienBalance;
  @JsonKey(name:"ledgerBalance")
  final double? ledgerBalance;

  AccountBalance(
      this.availableBalance,
      this.lienBalance,
      this.ledgerBalance
      );

  factory AccountBalance.fromJson(Object? data) => _$AccountBalanceFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccountBalanceToJson(this);

}