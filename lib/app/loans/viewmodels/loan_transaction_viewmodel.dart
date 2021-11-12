import 'dart:async';

import 'package:moniepoint_flutter/app/customer/user_account.dart';

mixin LoanTransactionViewModel {
  StreamController<bool> _isValidController = StreamController.broadcast();
  Stream<bool>? get isValid => _isValidController.stream;

  double? get amount => _amount;
  double? _amount;

  UserAccount? _payoutAccount;
  UserAccount? get payoutAccount => _payoutAccount;

  UserAccount? _repaymentAccount;
  UserAccount? get repaymentAccount => _repaymentAccount;

  void setAmount(double amount) => this._amount = amount;
  void setPayoutAccount(UserAccount? userAccount) =>
      this._payoutAccount = userAccount;

  void setRepaymentAccount(UserAccount? userAccount) =>
    this._repaymentAccount = userAccount;

  void checkValidity() {
    _isValidController.sink.add(validityCheck());
  }

  bool validityCheck();


  void dispose() {
    _isValidController.close();
  }
}
