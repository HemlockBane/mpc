import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_product_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:provider/provider.dart';

class LoansHomeViewModel extends BaseViewModel{



  StreamController<Resource<LoanProductStatus>> _loanProductStatusController =
      StreamController.broadcast();

  Stream<Resource<LoanProductStatus>> get loanProductStatusStream =>
      _loanProductStatusController.stream;

  Stream<Resource<LoanProductStatus>> getLoanProductStatus() {
    final json = runningLoan["shortTermLoanProductStatus"];
    final shortTermLoan = ShortTermLoanProductStatus.fromJson(json);
    final resource = Resource.success(LoanProductStatus(shortTermLoanProductStatus: shortTermLoan),);
    _loanProductStatusController.add(resource);
    return Stream.value(resource);
  }

  @override
  void dispose() {
    _loanProductStatusController.close();
    super.dispose();
  }
}

class LoanProductStatus {
  final ShortTermLoanProductStatus? shortTermLoanProductStatus;

  LoanProductStatus({this.shortTermLoanProductStatus});
}

final runningLoan = {
  "shortTermLoanProductStatus": {
    "status": "RUNNING",
    "shortTermLoanDetails": {
      "name": "Moniepoint Short Term Loan",
      "description": "Moniepoint Short Term Loan Description",
      "offerName": "Short Term Loan Available Offer",
      "loanAmount": 45000,
      "interestRate": 2,
      "interestAmount": 900,
      "totalRepayment": 45900,
      "penaltyAmount": 0,
      "amountPaid": 0,
      "outstandingAmount": 0,
      "tenor": 30,
      "dateRequested": "2021-10-28T00:40:28.000+0000",
      "dueDate": "2021-11-28T00:40:28.000+0000",
      "payoutAccount": "1234567890",
      "repaymentAccount": "0987654321",
      "overdueDays": 0,
      "overdue": false
    },
    "shortTermPendingLoanRequest": null,
    "shortTermLoanAdvert": null,
    "productActive": true
  }
};

final pendingLoan = {
  "shortTermLoanProductStatus": {
    "status": "AWAITING_APPROVAL",
    "shortTermLoanDetails": null,
    "shortTermPendingLoanRequest": {
      "name": "Moniepoint Short Term Loan",
      "description": "Moniepoint Short Term Loan Description",
      "offerName": "Short Term Loan Available Offer",
      "loanAmount": 45000,
      "interestRate": 2,
      "interestAmount": 900,
      "tenor": 30,
      "totalRepayment": 45900,
      "payoutAccount": "1234567890",
      "repaymentAccount": "1234567890",
      "shortTermLoanOffer": {
        "name": "Short Term Loan Available Offer",
        "offerReference": "2D3E2D701D2A45D597753D6490A768A4",
        "currencyCode": "NGN",
        "interestRateInPercentage": 2,
        "maxLoanAmount": 50000,
        "minLoanAmount": 40000,
        "tenorInDays": 30,
        "penaltyString": "Sample Penalty String",
        "termsAndConditionLink": "www.teamapt.com/terms-and-conditions",
        "status": "ACCEPTED",
        "expiresOn": "2021-10-28T11:46:40.000+0000"
      }
    },
    "shortTermLoanAdvert": null,
    "productActive": true
  }
};

final readyLoan = {
  "shortTermLoanProductStatus": {
    "status": "READY",
    "shortTermLoanDetails": null,
    "shortTermPendingLoanRequest": null,
    "shortTermLoanAdvert": {
      "name": "Moniepoint Short Term Loan",
      "description": "Moniepoint Short Term Loan Description",
      "minInterestRate": 2,
      "maxAmount": 50000,
      "penaltyString": "Penalty String"
    },
    "productActive": true
  }
};
