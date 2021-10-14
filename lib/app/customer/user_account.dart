import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_upgrade_state.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/customer/customer_account.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:collection/collection.dart';

part 'user_account.g.dart';

@JsonSerializable()
class UserAccount {
  int? id;
  @JsonKey(name:"account")
  CustomerAccount? customerAccount;
  AccountProvider? accountProvider;
  AccountBalance? accountBalance;
  Customer? customer;
  AccountStatus? accountStatus;

  UserAccount({
    this.id,
    this.customerAccount,
    this.accountProvider,
    this.accountBalance,
    this.customer
  });

  factory UserAccount.fromJson(Object? data) => _$UserAccountFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$UserAccountToJson(this);

  AccountState getAccountState() {
    if(this.customerAccount?.blocked == true) return AccountState.BLOCKED;
    if(this.accountStatus?.postNoDebit == true) return AccountState.PND;

    final shouldReUploadID = shouldReUploadIdentification();

    final shouldReUploadProof = shouldReUploadProofOfAddress();

    if(shouldReUploadID == true || shouldReUploadProof == true) {
      return AccountState.REQUIRE_DOCS;
    }

    final flags = accountStatus?.listFlags() ?? parentCustomer?.listFlags();

    if (flags == null || flags.isEmpty) return AccountState.COMPLETED;

    bool isCompleted = flags.where((element) => element?.status != true).isEmpty;

    if(!isCompleted) {
      //check if all flags are valid and it's pending verification flags
      final formFlags = flags.whereNot((element) {
        return element?.flagName == Flags.IDENTIFICATION_VERIFIED
            || element?.flagName == Flags.ADDRESS_VERIFIED ;
      }).toList();

      final isPendingVerification = formFlags.where((element) => element?.status != true).isEmpty;

      if(isPendingVerification) return AccountState.PENDING_VERIFICATION;
      else return AccountState.IN_COMPLETE;
    }

    return AccountState.COMPLETED;
  }

  bool shouldReUploadIdentification() {
    return (this.accountStatus?.customer?.reUploadID
        ?? this.customerAccount?.customer?.reUploadID) == true;
  }

  bool shouldReUploadProofOfAddress() {
    return (this.accountStatus?.customer?.reUploadProofOfAddress
        ?? this.customerAccount?.customer?.reUploadProofOfAddress) == true;
  }

  Customer? get parentCustomer => UserInstance().getUser()?.customers!.firstOrNull;
}