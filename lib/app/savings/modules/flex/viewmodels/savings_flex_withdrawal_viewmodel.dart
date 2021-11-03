import 'dart:async';

import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';


class SavingsFlexWithdrawalViewModel extends BaseViewModel with PaymentViewModel{

  @override
  bool validityCheck() => (this.amount ?? 0.00) >= 1 && sourceAccount != null;

  @override
  void setSourceAccount(UserAccount? userAccount) {
    super.setSourceAccount(userAccount);
    this.checkValidity();
  }

  @override
  void dispose() {
    super.dispose();
  }


}