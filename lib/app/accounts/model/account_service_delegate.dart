
import 'package:moniepoint_flutter/app/accounts/model/account_service.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:collection/collection.dart';


class AccountServiceDelegate with NetworkResource {
  late final AccountService _service;

  AccountServiceDelegate(AccountService service) {
    this._service = service;
  }

  Stream<Resource<AccountBalance>> getCustomerAccountBalance(int customerId) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () {
          final userAccounts = UserInstance().userAccounts;
          final userAccount = userAccounts.where((element) => element.customerAccount?.id == customerId).firstOrNull;
          // final balances = UserInstance().accountBalance;
          return Stream.value(userAccount?.accountBalance);
        },
        fetchFromRemote: () => this._service.getCustomerAccountBalance(customerId),
        saveRemoteData: (balance) async {
          UserInstance().setAccountBalance([balance]);
        }
    );
  }

  Stream<Resource<List<UserAccount>>> getUserAccountWithBalance() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => Stream.value(UserInstance().userAccounts),
        fetchFromRemote: () => this._service.getUserAccountsWithBalance(),
        saveRemoteData: (userAccounts) async {
          UserInstance().setUserAccounts(userAccounts);
        }
    );
  }

  Stream<Resource<AccountStatus>> getAccountStatus(int customerId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.getAccountStatus(customerId),
        processRemoteResponse: (resource) {
          AccountStatus? accountStatus = resource.data?.result;
          if (accountStatus != null) UserInstance().setAccountStatus(accountStatus);
        }
    );
  }

  Stream<Resource<TransferBeneficiary>> getAccountBeneficiary(String bankCode, String accountNumber) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.getBeneficiaryDetails(bankCode, accountNumber)
    );
  }

}