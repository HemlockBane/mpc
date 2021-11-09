
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

  Stream<Resource<AccountBalance>> getCustomerAccountBalance({required int customerId, bool useLocal = true}) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () {
          final userAccounts = UserInstance().userAccounts;
          final userAccount = userAccounts.where((element) => element.customerAccount?.id == customerId).firstOrNull;
          return Stream.value(userAccount?.accountBalance);
        },
        shouldFetchFromRemote: (localData) {
          final userAccounts = UserInstance().userAccounts;
          final userAccount = userAccounts.where((element) => element.customerAccount?.id == customerId).firstOrNull;
          return userAccount?.accountBalance == null || (useLocal == false);
        },
        fetchFromRemote: () => this._service.getCustomerAccountBalance(customerId),
        saveRemoteData: (balance) async {
          final userAccounts = UserInstance().userAccounts;
          userAccounts.forEach((element) {
            if(element.customerAccount?.id == customerId) element.accountBalance = balance;
          });
        }
    );
  }

  Stream<Resource<List<UserAccount>>> getUserAccountWithBalance({bool useLocal = true}) {
    return networkBoundResource(
        shouldFetchLocal: true,
        shouldFetchFromRemote: (localData) {
          final shouldReloadBalance = localData?.where((element) => element.accountBalance == null).isNotEmpty ?? false;
          return shouldReloadBalance || (useLocal == false);
        },
        fetchFromLocal: () => Stream.value(UserInstance().userAccounts),
        fetchFromRemote: () => this._service.getUserAccountsWithBalance(),
        saveRemoteData: (userAccounts) async {
          final sessionUserAccounts = UserInstance().userAccounts;
          for(var i = 0; i < userAccounts.length; i++) {
            final userAccount = userAccounts[i];
            sessionUserAccounts.forEach((sessionUserAccount) {
              if(userAccount.id == sessionUserAccount.id && userAccount.accountBalance != null) {
                sessionUserAccount.accountBalance = userAccount.accountBalance;
              }
            });
          }
        }
    );
  }


  Stream<Resource<AccountStatus>> getAccountStatus(int customerAccountId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.getAccountStatus(customerAccountId),
        processRemoteResponse: (resource) {
          AccountStatus? accountStatus = resource.data?.result;
          if (accountStatus != null) UserInstance().setAccountStatus(customerAccountId, accountStatus);
        }
    );
  }

  Stream<Resource<dynamic>> updateAllAccountStatus() async* {
    //Fetch the account status for all accounts
    final userAccounts = UserInstance().userAccounts;
    bool encounteredError = false;

    for(var i = 0; i < userAccounts.length && encounteredError == false; i++) {
      final userAccount = userAccounts[i];
      final dataSource = this.getAccountStatus(userAccount.customerAccount!.id!);
      await for (var data in dataSource) {
        if(data is Loading) yield data;
        if(data is Error) {
          encounteredError = true;
          yield data;
          break;
        }
        if(data is Success && i == userAccounts.length -1) {
          yield data;
          break;
        }
      }
    }
  }

  Stream<Resource<TransferBeneficiary>> getAccountBeneficiary(String bankCode, String accountNumber) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.getBeneficiaryDetails(bankCode, accountNumber)
    );
  }

}