import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class DashboardViewModel extends BaseViewModel {
  late final CustomerServiceDelegate _customerServiceDelegate;

  DashboardViewModel({AccountServiceDelegate? accountServiceDelegate, CustomerServiceDelegate? customerServiceDelegate})
      : super(accountServiceDelegate: accountServiceDelegate) {
    this._customerServiceDelegate = customerServiceDelegate ?? GetIt.I<CustomerServiceDelegate>();
  }

  final List<Tier> tiers = [];

  StreamController<bool> _dashboardController = StreamController.broadcast();
  Stream<bool> get dashboardController => _dashboardController.stream;

  Stream<Resource<AccountStatus>> fetchAccountStatus() {
    return this.accountServiceDelegate!.getAccountStatus(customerAccountId);
  }

  Stream<Resource<List<Tier>>> getTiers() {
    return _customerServiceDelegate.getSchemes(fetchFromRemote: false).map((event) {
      if((event is Success || event is Loading) && event.data?.isNotEmpty == true) {
        this.tiers.clear();
        this.tiers.addAll(event.data ?? []);
      }
      return event;
    });
  }

  void update() {
    _dashboardController.sink.add(true);
  }

  @override
  void dispose() {
    _dashboardController.close();
    super.dispose();
  }

}