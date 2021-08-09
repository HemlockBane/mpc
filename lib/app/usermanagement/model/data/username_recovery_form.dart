import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:rxdart/rxdart.dart';

class UsernameRecoveryForm with Validators {
  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;
  
  final _keyInputController = StreamController<String>.broadcast();
  Stream<String> get keyInputStream => _keyInputController.stream;

  final _requestBody = ForgotPasswordRequest()..withStep(ForgotPasswordStep.INITIATE);
  ForgotPasswordRequest get requestBody  => _requestBody;

  /// Denotes that only the account number is used to validate the form
  static const VALIDATING_ACCOUNT_NUMBER = 1;

  /// Denotes that only the bvn is used to validate the form
  static const VALIDATING_BVN = 2;

  /// Used to switch the validation mode that's required for the form
  int validationMode = VALIDATING_ACCOUNT_NUMBER;

  UsernameRecoveryForm() {
    _initState();
  }

  void _initState() {
    this._isValid = Rx.combineLatest([keyInputStream], (values) {
      if(validationMode == VALIDATING_ACCOUNT_NUMBER) {
        return _isAccountNumberValid(displayError: false);
      } else if(validationMode == VALIDATING_BVN) {
        return _isBVNValid(displayError: false);
      }
      return _isAccountNumberValid(displayError: false)
          && _isBVNValid(displayError: false);
    }).asBroadcastStream();
  }

  String? get getKey => _requestBody.key;

  void onAccountNumberChanged(String? text) {
    _requestBody.key = text;
    _keyInputController.sink.add(text ?? "");
    validationMode = VALIDATING_ACCOUNT_NUMBER;
    _isAccountNumberValid(displayError: true);
  }

  bool _isAccountNumberValid({bool displayError = false}) {
    final isValid = isAccountNumberValid(_requestBody.key);
    if (isValid) return true;
    final isEmpty = _requestBody.accountNumber?.isEmpty == true;
    if (displayError && !isValid) {
      _keyInputController.sink.addError(isEmpty
          ? "Account number is required"
          : "Invalid Account Number"
      );
    }
    return false;
  }

  void onBVNChanged(String? text) {
    _requestBody.key = text;
    _keyInputController.sink.add(text ?? "");
    validationMode = VALIDATING_BVN;
    _isBVNValid(displayError: true);
  }

  bool _isBVNValid({bool displayError = false}) {
    final isValid = isBVNValid(_requestBody.key);
    if (isValid) return true;
    if (displayError && !isValid) _keyInputController.sink
        .addError(_requestBody.key?.isEmpty == true ? "BVN is required" : "Invalid BVN");
    return false;
  }

  void reset() {
    _requestBody.key = "";
  }

  // @override
  void dispose() {
    _keyInputController.close();
    // super.dispose();
  }
}