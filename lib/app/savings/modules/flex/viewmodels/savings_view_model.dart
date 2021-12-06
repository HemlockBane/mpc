
import 'dart:async';

import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';

mixin SavingsViewModel {

  StreamController<bool> _isValidController = StreamController.broadcast();
  Stream<bool>? get isValid => _isValidController.stream;

  double? get amount => _amount;
  double? _amount;

  String get pin => _pin;
  String _pin = "";

  UserAccount? _sourceAccount;
  UserAccount? get sourceAccount => _sourceAccount;

  FlexSaving? _flexSaving;
  FlexSaving? get flexSavingAccount => _flexSaving;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setSourceAccount(UserAccount? userAccount) => this._sourceAccount = userAccount;
  void setAmount(double amount) => this._amount = amount;
  void setPin(String pin) => this._pin = pin;
  void setFlexSavingAccount(FlexSaving? flexSaving) => this._flexSaving = flexSaving;
  void setIsLoading(bool isLoading) {
    this._isLoading = isLoading;
  }

  void checkValidity() {
    _isValidController.sink.add(validityCheck());
  }

  bool validityCheck();

  void dispose() {
    _isValidController.close();
  }
}