import 'dart:async';
import 'dart:math';

import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';

mixin PaymentViewModel {

  StreamController<bool> _isValidController = StreamController.broadcast();
  Stream<bool>? get isValid => _isValidController.stream;

  Beneficiary? _beneficiary;
  Beneficiary? get beneficiary => _beneficiary;

  double? get amount => _amount;
  double? _amount;

  bool? get saveBeneficiary => _saveBeneficiary;
  bool? _saveBeneficiary = false;

  String get pin => _pin;
  String _pin = "";

  void setSaveBeneficiary(bool save) => this._saveBeneficiary = save;
  void setBeneficiary(Beneficiary beneficiary) =>this._beneficiary = beneficiary;
  void setAmount(double amount) => this._amount = amount;
  void setPin(String pin) => this._pin = pin;

  void checkValidity() {
    _isValidController.sink.add(validityCheck());
  }

  bool validityCheck();

  void dispose() {
    _isValidController.close();
  }
}