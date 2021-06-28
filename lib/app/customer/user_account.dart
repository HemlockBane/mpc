import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/customer/customer_account.dart';

part 'user_account.g.dart';

@JsonSerializable()
class UserAccount {
  int? id;
  @JsonKey(name:"account")
  CustomerAccount? customerAccount;
  AccountProvider? accountProvider;
  AccountBalance? accountBalance;
  Customer? customer;

  UserAccount({
    this.id,
    this.customerAccount,
    this.accountProvider,
    this.accountBalance,
    this.customer
  });

  factory UserAccount.fromJson(Object? data) => _$UserAccountFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$UserAccountToJson(this);
}