import 'dart:async';

import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/loans/models/available_short_term_loan_offer.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_offers.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_transaction_viewmodel.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class LoanRequestViewModel extends BaseViewModel with PaymentViewModel {
  final StreamController<Tuple<int, bool>> _pageFormController =
      StreamController.broadcast();

  Stream<Tuple<int, bool>> get pageFormStream => _pageFormController.stream;

  final StreamController<double> _interestController = StreamController.broadcast();
  Stream<double> get interestStream => _interestController.stream;


  final StreamController<double> _switchListTileController = StreamController.broadcast();
  Stream<double> get shouldUseSameAccountStream => _switchListTileController.stream;

  late AvailableShortTermLoanOffer _selectedLoanOffer;
  AvailableShortTermLoanOffer get selectedLoanOffer => _selectedLoanOffer;

  bool  _usePayoutAccountForRepayment = true;
  bool get usePayoutAccountForRepayment => _usePayoutAccountForRepayment;

  Stream<Resource<List<List<Object>?>>> getShortTermLoanOffers() {
    final loanOffers = ShortTermLoanOffers.fromJson(loanOffersJson);
    final items = [loanOffers.availableLoanOffers,loanOffers.futureLoanOffers];
    final resource = Resource.success(items);
    return Stream.value(resource);

  }

  Stream<AvailableShortTermLoanOffer> getSelectedOffer() {
    return Stream.value(_selectedLoanOffer);
  }


  void setSelectedLoanOffer(AvailableShortTermLoanOffer loanOffer) {
    print("selected loan offer ${loanOffer.toJson()}");
    _selectedLoanOffer = loanOffer;
  }
  void setSwitchState(bool value) {
    _usePayoutAccountForRepayment = value;
  }

  void moveToNext(int currentIndex, {bool skip = false}) {
    _pageFormController.sink.add(Tuple(currentIndex, skip));
  }

  void calculateInterestRate(double loanAmount) {
    final prt = (loanAmount *
        selectedLoanOffer.minInterestRate! *
        selectedLoanOffer.maxPeriod!);
    _interestController.add(prt / 100);
  }



  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    this.checkValidity();
  }


  @override
  bool validityCheck() {
    return (this.amount ?? 0.00) >= 1 && sourceAccount != null;
  }

  @override
  void dispose() {
    _pageFormController.close();
    _interestController.close();
    _switchListTileController.close();
    super.dispose();
  }
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