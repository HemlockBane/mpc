import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_upgrade_state.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/customer/customer_account.dart';
import 'package:moniepoint_flutter/app/customer/scheme_code.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';
import 'package:collection/collection.dart';


abstract class BaseViewModel with ChangeNotifier {

  AccountServiceDelegate? accountServiceDelegate;

  BaseViewModel({this.accountServiceDelegate}) {
    this.accountServiceDelegate = accountServiceDelegate ?? GetIt.I<AccountServiceDelegate>();
  }

  final StreamController<AccountBalance?> _balanceController = StreamController.broadcast();
  Stream<AccountBalance?> get balanceStream => _balanceController.stream;

  final StreamController<Resource<List<AccountBalance?>>> _accountsBalanceController = StreamController.broadcast();
  Stream<Resource<List<AccountBalance?>>> get accountsBalanceStream => _accountsBalanceController.stream;

  Stream<Resource<AccountBalance>> getCustomerAccountBalance({int? accountId, bool useLocal = true}) {
    return accountServiceDelegate!.getCustomerAccountBalance(
        customerId: accountId ?? customerAccountId,
        useLocal: useLocal
    ).map((event) {
      if ((event is Loading && event.data != null && useLocal) && !_balanceController.isClosed) _balanceController.sink.add(event.data);

      if (event is Success && !_balanceController.isClosed){
        _balanceController.sink.add(event.data);
      } else if(event is Success && _balanceController.isClosed) {
        print("I think we have a closed event here");
      }
      return event;
    });
  }

  Stream<Resource<List<UserAccount>>> getUserAccountsBalance({bool useLocal = true}) {
    return accountServiceDelegate!.getUserAccountWithBalance(useLocal: useLocal).map((event) {
      if ((event is Loading && event.data != null && useLocal) && !_accountsBalanceController.isClosed) {
        _accountsBalanceController.sink.add(Resource.loading(event.data!.map((e) => e.accountBalance).toList()));
      } else if(event is Loading && !useLocal && !_accountsBalanceController.isClosed) {
        _accountsBalanceController.sink.add(Resource.loading(null));
      }
      else if (event is Success && !_accountsBalanceController.isClosed) {
        _accountsBalanceController.sink.add(Resource.success(event.data!.map((e) => e.accountBalance).toList()));
      }else if(event is Error<List<UserAccount>> && !_accountsBalanceController.isClosed) {
        _accountsBalanceController.sink.add(Resource.error(err: ServiceError(message: event.message ?? "")));
      }
      print(event);
      return event;
    });
  }

  List<Customer> get customers => UserInstance().getUser()?.customers ?? [];
  Customer? get customer => UserInstance().getUser()?.customers?.first;

  List<UserAccount> get userAccounts  {
    final userAccounts = UserInstance().userAccounts;
    if(userAccounts.isEmpty) {
      return customer?.customerAccountUsers?.map((e) {
        return UserAccount(
            id: e.customerAccount?.id,
            customerAccount: e.customerAccount,
            customer: e.customerAccount?.customer
        );
      }).toList() ?? [];
    }
    return UserInstance().userAccounts;
  }

  String get cbaCustomerId => UserInstance().getUser()
      ?.customers?.first.customerAccountUsers
      ?.first.customerAccount?.cbaCustomerId ?? "";

  String get primaryCbaCustomerId => UserInstance().getUser()
      ?.customers?.first.primaryCbaCustomerId ?? "";

  int get customerId => UserInstance().getUser()?.customers?.first.id ?? 0;
  int get customerAccountId => UserInstance().getUser()?.customers?.first.customerAccountUsers?.first.customerAccount?.id ?? 0;

  String get accountName => UserInstance().getUser()?.customers?.first.customerAccountUsers?.first.customerAccount?.accountName ?? "";
  String get accountNumber => UserInstance().getUser()?.customers?.first.customerAccountUsers?.first.customerAccount?.accountNumber ?? "";
  String get accountProviderCode => UserInstance().getUser()?.customers?.first.accountProvider?.centralBankCode ?? "";

  String customerAccountNumber({int? accountId}) {
    if(accountId == null) return accountNumber;
    final mCustomerAccountUser = customer?.customerAccountUsers?.where((element) => element.customerAccount?.id == accountId).firstOrNull;
    return mCustomerAccountUser?.customerAccount?.accountNumber ?? accountNumber;
  }

  String customerAccountName({int? accountId}) {
    if(accountId == null) return accountName;
    final mCustomerAccountUser = customer?.customerAccountUsers?.where((element) => element.customerAccount?.id == accountId).firstOrNull;
    return mCustomerAccountUser?.customerAccount?.accountName ?? accountName;
  }

  String? getUserQualifiedTierName(int customerAccountId) {
    final customerAccountUsers = customer?.customerAccountUsers?.where((element) => element.customerAccount?.id ==customerAccountId).firstOrNull;
    if(customerAccountUsers == null || customerAccountUsers.customerAccount == null) return null;
    final customerAccount = customerAccountUsers.customerAccount;
    return customerAccount?.schemeCode?.name;
  }

  SchemeCode? getUserQualifiedScheme(int customerAccountId) {
    final customerAccountUsers = customer?.customerAccountUsers?.where((element) => element.customerAccount?.id ==customerAccountId).firstOrNull;
    if(customerAccountUsers == null || customerAccountUsers.customerAccount == null) return null;
    final customerAccount = customerAccountUsers.customerAccount;
    return customerAccount?.schemeCode;
  }

  int? getCustomerAccountIdByAccountNumber (String? accountNumber) {
    List<UserAccount> accounts = userAccounts.where((element) {
      return element.customerAccount?.accountNumber == accountNumber;
    }).toList();
    return accounts.firstOrNull?.customerAccount?.id;
  }

  CustomerAccount? getCustomerAccountByAccountNumber (String? accountNumber) {
    List<UserAccount> accounts = userAccounts.where((element) {
      return element.customerAccount?.accountNumber == accountNumber;
    }).toList();
    return accounts.firstOrNull?.customerAccount;
  }

  int? getCurrentAccountTierNumber(int userAccountId) {
    String? tierName = getUserQualifiedTierName(userAccountId);
    if(tierName == null || tierName.trim().isEmpty) return null;

    //let's get the last word in the string
    final words = tierName.split(" ");
    final lastWord = words[words.length - 1];

    final integerValue = int.tryParse(lastWord);

    if(integerValue != null) return integerValue;

    //check if the word is either one,two or three...
    switch(lastWord.toLowerCase()) {
      case "one":
        return 1;
      case "two":
        return 2;
      case "three":
        return 3;
      default:
        return null;
    }
  }

  AccountState getAccountState () {
    return userAccounts.firstOrNull?.getAccountState() ?? AccountState.COMPLETED;
  }

  UserAccount? getUserAccountById(int userAccountId) => UserInstance().getUserAccount(userAccountId);

  @override
  void dispose() {
    _balanceController.close();
    _accountsBalanceController.close();
    super.dispose();
  }

}