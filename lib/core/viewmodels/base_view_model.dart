import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

abstract class BaseViewModel with ChangeNotifier {

  AccountServiceDelegate? accountServiceDelegate;

  BaseViewModel({this.accountServiceDelegate}) {
    this.accountServiceDelegate = accountServiceDelegate ?? GetIt.I<AccountServiceDelegate>();
  }

  final StreamController<AccountBalance?> _balanceController = StreamController.broadcast();
  Stream<AccountBalance?> get balanceStream => _balanceController.stream;

  Stream<Resource<AccountBalance>> getCustomerAccountBalance() {
    return accountServiceDelegate!.getCustomerAccountBalance(customerAccountId).map((event) {
      if (event is Success && !_balanceController.isClosed) _balanceController.sink.add(event.data);
      return event;
    });
  }

  Customer? get customer => UserInstance().getUser()?.customers?.first;

  int get customerId => UserInstance().getUser()?.customers?.first.id ?? 0;
  int get customerAccountId => UserInstance().getUser()?.customers?.first.customerAccountUsers?.first.customerAccount?.id ?? 0;

  String get accountName => UserInstance().getUser()?.customers?.first.customerAccountUsers?.first.customerAccount?.accountName ?? "";
  String get accountNumber => UserInstance().getUser()?.customers?.first.customerAccountUsers?.first.customerAccount?.accountNumber ?? "";

  @override
  void dispose() {
    _balanceController.close();
    super.dispose();
  }

}