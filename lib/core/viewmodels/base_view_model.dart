import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';

abstract class BaseViewModel with ChangeNotifier {

  AccountServiceDelegate? accountServiceDelegate;

  BaseViewModel({this.accountServiceDelegate}) {
    this.accountServiceDelegate = accountServiceDelegate ?? GetIt.I<AccountServiceDelegate>();
  }

  final StreamController<AccountBalance?> _balanceController = StreamController.broadcast();
  Stream<AccountBalance?> get balanceStream => _balanceController.stream;

  final StreamController<Resource<List<AccountBalance?>>> _accountsBalanceController = StreamController.broadcast();
  Stream<Resource<List<AccountBalance?>>> get accountsBalanceStream => _accountsBalanceController.stream;

  Stream<Resource<AccountBalance>> getCustomerAccountBalance({bool useLocal = true}) {
    return accountServiceDelegate!.getCustomerAccountBalance(customerAccountId).map((event) {
      if ((event is Loading && event.data != null && useLocal) && !_balanceController.isClosed) _balanceController.sink.add(event.data);
      if (event is Success && !_balanceController.isClosed) _balanceController.sink.add(event.data);
      return event;
    });
  }

  Stream<Resource<List<UserAccount>>> getUserAccountsBalance({bool useLocal = true}) {
    return accountServiceDelegate!.getUserAccountWithBalance().map((event) {
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
      return event;
    });
  }

  List<Customer> get customers => UserInstance().getUser()?.customers ?? [];
  Customer? get customer => UserInstance().getUser()?.customers?.first;

  List<UserAccount> get userAccounts  {
    final userAccounts = UserInstance().userAccounts;
    if(userAccounts.isEmpty) {
      return customers.map((e) {
        return UserAccount(
            id: e.customerAccountUsers!.first.customerAccount!.id,
            customerAccount: e.customerAccountUsers!.first.customerAccount,
            customer: e
        );
      }).toList();
    }
    return UserInstance().userAccounts;
  }

  int get customerId => UserInstance().getUser()?.customers?.first.id ?? 0;
  int get customerAccountId => UserInstance().getUser()?.customers?.first.customerAccountUsers?.first.customerAccount?.id ?? 0;

  String get accountName => UserInstance().getUser()?.customers?.first.customerAccountUsers?.first.customerAccount?.accountName ?? "";
  String get accountNumber => UserInstance().getUser()?.customers?.first.customerAccountUsers?.first.customerAccount?.accountNumber ?? "";
  String get accountProviderCode => UserInstance().getUser()?.customers?.first.accountProvider?.centralBankCode ?? "";

  @override
  void dispose() {
    _balanceController.close();
    _accountsBalanceController.close();
    super.dispose();
  }

}