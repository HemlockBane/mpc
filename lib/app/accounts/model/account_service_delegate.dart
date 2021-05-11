
import 'package:moniepoint_flutter/app/accounts/model/account_service.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class AccountServiceDelegate with NetworkResource {
  late final AccountService _service;

  AccountServiceDelegate(AccountService service) {
    this._service = service;
  }

  Stream<Resource<AccountBalance>> getCustomerAccountBalance(int customerId) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.getCustomerAccountBalance(customerId)
    );
  }

  Stream<Resource<AccountStatus>> getAccountStatus(int customerId) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.getAccountStatus(customerId),
        processRemoteResponse: (resource) {
          AccountStatus? accountStatus = resource.data?.result;
          if (accountStatus != null) UserInstance().setAccountStatus(accountStatus);
        }
    );
  }

}