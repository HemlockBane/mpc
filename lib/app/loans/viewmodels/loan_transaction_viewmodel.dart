

import 'dart:async';

import 'package:moniepoint_flutter/app/customer/user_account.dart';

mixin LoanTransactionViewModel{
  StreamController<bool> _isValidController = StreamController.broadcast();
  Stream<bool>? get isValid => _isValidController.stream;

  double? get amount => _amount;
  double? _amount;

  UserAccount? _payoutAccount;
  UserAccount? get payoutAccount => _payoutAccount;

  void setAmount(double amount) => this._amount = amount;
  void setPayoutAccount(UserAccount? userAccount) => this._payoutAccount = userAccount;


  void checkValidity() {
    _isValidController.sink.add(validityCheck());
  }

  bool validityCheck();

  void dispose() {
    _isValidController.close();
  }
}


// @override
// bool validityCheck() {
//   return (this.amount ?? 0.00) >= 1 &&
//       payoutAccount != null &&
//       repaymentAccount != null;
// }

// UserAccount? _repaymentAccount;
// UserAccount? get repaymentAccount => _repaymentAccount;

//
// @override
// void setPayoutAccount(UserAccount? userAccount) {
//   super.setPayoutAccount(userAccount);
//   checkValidity();
// }
//
// void setRepaymentAccount(UserAccount? userAccount) {
//   this._repaymentAccount = userAccount;
//   checkValidity();
// }


