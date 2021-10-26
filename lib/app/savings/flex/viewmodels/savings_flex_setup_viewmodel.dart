import 'dart:async';

import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';


class SavingsFlexSetupViewModel extends BaseViewModel with PaymentViewModel{

  final StreamController<Tuple<int, bool>> _pageFormController = StreamController.broadcast();
  Stream<Tuple<int, bool>> get pageFormStream => _pageFormController.stream;

  void moveToNext(int currentIndex, {bool skip = false}) {
    _pageFormController.sink.add(Tuple(currentIndex, skip));
  }


  void moveToPrev({bool skip = false}) {
    _pageFormController.sink.add(Tuple(-1,skip));
  }


  @override
  bool validityCheck() => (this.amount ?? 0.00) >= 1 && sourceAccount != null;

  @override
  void setSourceAccount(UserAccount? userAccount) {
    super.setSourceAccount(userAccount);
    this.checkValidity();
  }

  @override
  void dispose() {
    _pageFormController.close();
    super.dispose();
  }


}