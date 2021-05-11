import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class DashboardViewModel extends BaseViewModel {

  DashboardViewModel({AccountServiceDelegate? accountServiceDelegate})
      : super(accountServiceDelegate: accountServiceDelegate);

  Stream<Resource<AccountStatus>> fetchAccountStatus() {
    return this.accountServiceDelegate!.getAccountStatus(customerAccountId);
  }

}