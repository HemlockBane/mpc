import 'dart:async';

import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/loans/models/available_short_term_loan_offer.dart';
import 'package:moniepoint_flutter/app/loans/models/loan_request_confirmation.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_offers.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_transaction_viewmodel.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/payment_view_model.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class LoanRequestViewModel extends BaseViewModel with LoanTransactionViewModel {
  final StreamController<PageInfo> _pageFormController =
      StreamController.broadcast();
  Stream<PageInfo> get pageFormStream => _pageFormController.stream;

  final StreamController<double> _interestController =
      StreamController.broadcast();
  Stream<double> get interestStream => _interestController.stream;

  final StreamController<double> _switchListTileController =
      StreamController.broadcast();
  Stream<double> get shouldUseSameAccountStream =>
      _switchListTileController.stream;

  late AvailableShortTermLoanOffer _selectedLoanOffer;
  AvailableShortTermLoanOffer get selectedLoanOffer => _selectedLoanOffer;

  bool _usePayoutAccountForRepayment = true;
  bool get usePayoutAccountForRepayment => _usePayoutAccountForRepayment;

  double _interestAmount = 0.0;
  double get interestAmount => _interestAmount;

  double get totalRepayment => _interestAmount + this.amount!;

  Stream<Resource<List<List<Object>?>>> getShortTermLoanOffers() {
    final loanOffers = ShortTermLoanOffers.fromJson(loanOffersJson);
    final items = [loanOffers.availableLoanOffers, loanOffers.futureLoanOffers];
    final resource = Resource.success(items);
    return Stream.value(resource);
  }

  Stream<AvailableShortTermLoanOffer> getSelectedOffer() {
    return Stream.value(_selectedLoanOffer);
  }

  void setSelectedLoanOffer(AvailableShortTermLoanOffer loanOffer) {
    print("viewmodel: selected loan offer ${loanOffer.toJson()}");
    _selectedLoanOffer = loanOffer;
  }

  void setSwitchState(bool value) {
    _usePayoutAccountForRepayment = value;
  }

  void reset(){
    setSwitchState(true);
    setPayoutAccount(null);
    setRepaymentAccount(null);
  }

  void moveToNext(int currentIndex, AvailableShortTermLoanOffer loanOffer,
      {bool skip = false}) {
    _pageFormController.sink
        .add(PageInfo(loanOffer: loanOffer, currentIndex: currentIndex));
  }

  void calculateInterestAmount(double loanAmount) {
    final amount = (loanAmount *
        selectedLoanOffer.minInterestRate!);
    _interestAmount = amount / 100;
    _interestController.add(_interestAmount);
  }


  LoanRequestConfirmation getLoanRequestConfirmation(){
    final confirmation = LoanRequestConfirmation(
      loanAmount: this.amount,
      totalRepayment: totalRepayment,
      interestAmount: interestAmount,
      repaymentAccount: repaymentAccount,
      payoutAccount: payoutAccount,
      loanOffer: selectedLoanOffer,
    );

    // print("confirmation: ${confirmation.toJson()}");
    return confirmation;
  }

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    this.checkValidity();
  }

  @override
  void setPayoutAccount(UserAccount? userAccount) {
    super.setPayoutAccount(userAccount);
    this.checkValidity();
  }

  @override
  void setRepaymentAccount(UserAccount? userAccount) {
    super.setRepaymentAccount(userAccount);
    this.checkValidity();
  }

  @override
  bool validityCheck() {
    return (this.amount ?? 0.00) >= 1 &&
        payoutAccount != null &&
        repaymentAccount != null;
  }

  @override
  void dispose() {
    _pageFormController.close();
    _interestController.close();
    _switchListTileController.close();
    super.dispose();
  }
}





class PageInfo {
  int currentIndex;
  bool? skip;
  AvailableShortTermLoanOffer loanOffer;

  PageInfo({required this.currentIndex, this.skip, required this.loanOffer});
}

final loanOffersJson = {
  "availableLoanOffers": [
    {
      "offerName": "Short Term Loan Available Offer",
      "offerReference": "2D3E2D701D2A45D597753D6490A768A4",
      "maximumAmount": 50000,
      "minInterestRate": 2,
      "maxPeriod": 30,
      "penaltyString": "Sample Penalty String",
      "termsAndConditions": "www.teamapt.com/terms-and-conditions"
    },
    {
      "offerName": "Short Term Loan Available Offer 2",
      "offerReference": "2D3E2D701D2A45D597753D6490A768A5",
      "maximumAmount": 40000,
      "minInterestRate": 2,
      "maxPeriod": 20,
      "penaltyString": "Sample Penalty String",
      "termsAndConditions": "www.teamapt.com/terms-and-conditions"
    }
  ],
  "futureLoanOffers": [
    {
      "offerName": "Short Term Loan Available Offer",
      "maximumAmount": 50000,
      "minInterestRate": 2,
      "maxPeriod": 30,
      "eligibilityString": "Sample Eligibility String",
    }
  ]
};
