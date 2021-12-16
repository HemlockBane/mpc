import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_category.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/models/TransactionRequestContract.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/main.dart';

///@author Paul Okeke

abstract class NavigationInterpreter {

  static const IN_APP = "in-app";
  static const EXTERNAL_URL = "external";

  NavigationInterpreter interpret(Map<String, dynamic>? params);

  NavigationInterpreter();

  factory NavigationInterpreter.interpret(String url) {
    final uri = Uri.parse(url);

    if(uri.pathSegments.length <= 1) return _DefaultNavigationInterpreter();

    final urlType = uri.pathSegments[0];
    final page = uri.pathSegments[1];
    final params = uri.queryParameters;

    if(urlType != IN_APP) return _DefaultNavigationInterpreter();

    switch(page) {
      case "account-restricted":
        return _AccountRestrictedNavigationInterpreter().interpret(params);
      case "regularize-documents":
        return _RegularizeDocumentsNavigationInterpreter().interpret(params);
      case "account-blocked":
        return _AccountBlockedNavigationInterpreter().interpret(params);
      case "account-upgrade-in-progress":
        return _AccountInProgressNavigationInterpreter().interpret(params);
      case "upgrade-account":
        return _AccountUpgradeNavigationInterpreter().interpret(params);
      case "account-status":
        return _AccountStatusNavigationInterpreter().interpret(params);

      //Account Statement
      case "account-statement":
        return _AccountStatementNavigationInterpreter().interpret(params);
      case "transaction-details":
        return _TransferDetailsNavigationInterpreter().interpret(params);

      //Transfer
      case "transfer":
        return _TransferNavigationInterpreter().interpret(params);
      case "transfer-beneficiary":
        return _TransferBeneficiaryNavigationInterpreter().interpret(params);
      case "transfer-beneficiary-amount-narration":
        return _TransferReplayNavigationInterpreter().interpret(params);

      //Airtime
      case "airtime":
        return _AirtimeNavigationInterpreter().interpret(params);
      case "data":
        return _AirtimeNavigationInterpreter().interpret(params);
      case "airtime-beneficiary":
        return _AirtimeBeneficiaryNavigationInterpreter().interpret(params);
      case "airtime-beneficiary-provider-amount":
        return _AirtimeBeneficiaryNavigationInterpreter().interpret(params);
      case "data-beneficiary":
        return _DataBeneficiaryNavigationInterpreter().interpret(params);
      case "data-beneficiary-provider-item":
        return _DataBeneficiaryNavigationInterpreter().interpret(params);

      //Bill
      case "bill-payment":
        return _BillNavigationInterpreter().interpret(params);
      case "bill-payment-biller":
        return _BillPaymentBillerNavigationInterpreter().interpret(params);
      case "bill-payment-biller-product":
        return _BillPaymentBillerNavigationInterpreter().interpret(params);
      case "bill-payment-history":
        return _BillHistoryNavigationInterpreter().interpret(params);
      case "bill-payment-history-item":
        return _BillHistoryDetailNavigationInterpreter().interpret(params);
    }
    return _DefaultNavigationInterpreter();
  }
}

class _DefaultNavigationInterpreter extends NavigationInterpreter {
  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    return this;
  }
}

///_AccountStatusNavigationInterpreter
///
class _AccountStatusNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;
    final userAccountId = params["userAccountId"];
    navigatorKey.currentState?.pushNamed(
        Routes.ACCOUNT_STATUS,
        arguments: {"userAccountId": userAccountId}
    );
    return this;
  }

}

///_RegularizeDocumentsNavigationInterpreter
///
class _RegularizeDocumentsNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;
    final userAccountId = params["userAccountId"];
    navigatorKey.currentState?.pushNamed(
        Routes.ACCOUNT_REGULARIZE_DOCS,
        arguments: {"userAccountId": userAccountId}
    );
    return this;
  }

}

///_AccountBlockedNavigationInterpreter
///
class _AccountBlockedNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;
    final userAccountId = params["userAccountId"];
    navigatorKey.currentState?.pushNamed(
        Routes.ACCOUNT_BLOCKED_STATE,
        arguments: {"userAccountId": userAccountId}
    );
    return this;
  }

}

///_AccountInProgressNavigationInterpreter
///
class _AccountInProgressNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;
    final userAccountId = params["userAccountId"];
    navigatorKey.currentState?.pushNamed(
        Routes.ACCOUNT_IN_PROGRESS_STATE,
        arguments: {"userAccountId": userAccountId}
    );
    return this;
  }

}

///_AccountRestrictedNavigationInterpreter
///
class _AccountRestrictedNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;
    final userAccountId = params["userAccountId"];
    navigatorKey.currentState?.pushNamed(
        Routes.ACCOUNT_PND_STATE,
        arguments: {"userAccountId": userAccountId}
    );
    return this;
  }

}

///_AccountUpgradeNavigationInterpreter
///
class _AccountUpgradeNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;
    final userAccountId = params["userAccountId"];
    navigatorKey.currentState?.pushNamed(
        Routes.ACCOUNT_UPGRADE_REQUIRED_STATE,
        arguments: {"userAccountId": userAccountId}
    );
    return this;
  }

}


///_AccountStatementNavigationInterpreter
///
class _AccountStatementNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;
    final userAccountId = params["userAccountId"];
    navigatorKey.currentState?.pushNamed(
        Routes.ACCOUNT_TRANSACTIONS,
        arguments: {"userAccountId": userAccountId}
    );
    return this;
  }

}

///_AccountStatementNavigationInterpreter
///
class _TransferDetailsNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;
    final reference = params["transactionReference"];
    navigatorKey.currentState?.pushNamed(
        Routes.ACCOUNT_TRANSACTIONS_DETAIL,
        arguments: {
          "transactionRef": reference,
        }
    );
    return this;
  }

}



///_TransferNavigationInterpreter
///
class _TransferNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    navigatorKey.currentState?.pushNamed(Routes.TRANSFER);
    return this;
  }

}


///_TransferBeneficiaryNavigationInterpreter
///
class _TransferBeneficiaryNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;

    final identifier = params["beneficiaryIdentifier"];
    final beneficiaryName = params["beneficiaryName"];
    final providerName = params["providerName"];
    final providerCode = params["providerCode"];

    if(identifier == null || beneficiaryName == null
        || providerName == null || providerCode == null) return this;

    final contract = TransactionRequestContract(
        intent: TransferBeneficiary(
          accountName: beneficiaryName,
          accountNumber: identifier,
          accountProviderName: providerName,
          accountProviderCode: providerCode
        ),
        requestType: TransactionRequestContractType.BEGIN_TRANSFER
    );
    navigatorKey.currentState?.pushNamed(Routes.TRANSFER, arguments: contract);
    return this;
  }

}

///_TransferReplayNavigationInterpreter
///
class _TransferReplayNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;

    final identifier = params["beneficiaryIdentifier"];
    final beneficiaryName = params["beneficiaryName"];
    final providerName = params["providerName"];
    final providerCode = params["providerCode"];
    final narration = params["narration"];
    final amount = params["amount"];

    if(identifier == null || beneficiaryName == null
        || providerName == null || providerCode == null) return this;

    final contract = TransactionRequestContract(
        intent: AccountTransaction(
            transactionDate: 0,
            transactionRef: "",
            beneficiaryBankName: providerName,
            beneficiaryBankCode: providerCode,
            beneficiaryName: beneficiaryName,
            beneficiaryIdentifier: identifier,
            amount: double.tryParse(amount),
            narration: narration
        ),
        requestType: TransactionRequestContractType.REPLAY
    );
    navigatorKey.currentState?.pushNamed(Routes.TRANSFER, arguments: contract);
    return this;
  }

}


///_AirtimeNavigationInterpreter
///
class _AirtimeNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    navigatorKey.currentState?.pushNamed(Routes.AIRTIME);
    return this;
  }

}

///_AirtimeBeneficiaryNavigationInterpreter
///
class _AirtimeBeneficiaryNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;

    final identifier = params["beneficiaryIdentifier"];
    final beneficiaryName = params["beneficiaryName"];
    final providerName = params["providerName"];
    final providerCode = params["providerCode"];
    final amount = params["amount"];

    if(identifier == null || beneficiaryName == null
        || providerName == null || providerCode == null) return this;

    final contract = TransactionRequestContract(
        intent: AccountTransaction(
          transactionDate: 0,
          transactionRef: "",
          beneficiaryBankName: providerName,
          beneficiaryBankCode: providerCode,
          beneficiaryName: beneficiaryName,
          beneficiaryIdentifier: identifier,
          amount: double.tryParse(amount),
        ),
        requestType: TransactionRequestContractType.REPLAY
    );
    navigatorKey.currentState?.pushNamed(Routes.AIRTIME, arguments: contract);
    return this;
  }

}

///_DataBeneficiaryNavigationInterpreter
///
class _DataBeneficiaryNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;

    final identifier = params["beneficiaryIdentifier"];
    final beneficiaryName = params["beneficiaryName"];
    final providerName = params["providerName"];
    final providerCode = params["providerCode"];
    final itemPlan = params["itemPlan"];
    final amount = params["amount"];

    if(identifier == null || beneficiaryName == null
        || providerName == null || providerCode == null) return this;

    final contract = TransactionRequestContract(
        intent: AccountTransaction(
          transactionDate: 0,
          transactionRef: "",
          beneficiaryBankName: providerName,
          beneficiaryBankCode: providerCode,
          beneficiaryName: beneficiaryName,
          beneficiaryIdentifier: identifier,
          providerIdentifier: itemPlan,
          amount: double.tryParse(amount),
          transactionCategory: TransactionCategory.DATA
        ),
        requestType: TransactionRequestContractType.REPLAY
    );
    navigatorKey.currentState?.pushNamed(Routes.AIRTIME, arguments: contract);
    return this;
  }

}

///_BillNavigationInterpreter
///
class _BillNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    navigatorKey.currentState?.pushNamed(Routes.BILL);
    return this;
  }

}

class _BillHistoryNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    navigatorKey.currentState?.pushNamed(Routes.BILL_HISTORY);
    return this;
  }

}

class _BillHistoryDetailNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    if(params == null) return this;
    final historyId = int.tryParse(params["billHistoryID"]);
    if(historyId == null) return this;
    navigatorKey.currentState?.pushNamed(Routes.BILL_DETAIL, arguments: historyId);
    return this;
  }

}

///_BillPaymentBillerNavigationInterpreter
///
class _BillPaymentBillerNavigationInterpreter extends NavigationInterpreter {

  @override
  NavigationInterpreter interpret(Map<String, dynamic>? params) {
    navigatorKey.currentState?.pushNamed(Routes.AIRTIME);
    return this;
  }

}




