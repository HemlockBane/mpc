import 'dart:async';

import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/loans/models/available_short_term_loan_offer.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_transaction_viewmodel.dart';
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
