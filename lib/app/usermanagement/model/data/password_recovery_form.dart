import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:rxdart/rxdart.dart';

import 'forgot_password_request.dart';

class PasswordRecoveryForm with ChangeNotifier, Validators {
  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;

  // final _accountNumberController = StreamController<String>.broadcast();
  // Stream<String> get accountNumberStream => _accountNumberController.stream;

  final _usernameController = StreamController<String>.broadcast();
  Stream<String> get usernameStream => _usernameController.stream;

  final _requestBody = ForgotPasswordRequest()..withStep(ForgotPasswordStep.INITIATE);
  ForgotPasswordRequest get requestBody  => _requestBody;

  PasswordRecoveryForm() {
    _initState();
  }

  void _initState() {
    this._isValid = Rx.combineLatest([usernameStream], (values) {
      return _isUsernameValid(displayError: false);
    }).asBroadcastStream();
  }

  // void onAccountNumberChanged(String? text) {
  //   _requestBody.accountNumber = text;
  //   _isAccountNumberValid(displayError: true);
  // }
  //
  // bool _isAccountNumberValid({bool displayError = false}) {
  //   final isValid = isAccountNumberValid(_requestBody.accountNumber);
  //   if (isValid) return true;
  //   if (displayError && !isValid) _accountNumberController.sink
  //       .addError(_requestBody.accountNumber?.isEmpty == true ? "Account number is required" : "Invalid Account Number");
  //   return false;
  // }

  void onUsernameChanged(String? text) {
    _requestBody.username = text;
    _usernameController.sink.add(text ?? "");
    _isUsernameValid(displayError: true);
  }

  bool _isUsernameValid({bool displayError = false}) {
    final isValid = _requestBody.username?.isNotEmpty == true;
    if (isValid) return true;
    if (displayError && !isValid) _usernameController.sink.addError("Username is required");
    return false;
  }

  @override
  void dispose() {
    // _accountNumberController.close();
    _usernameController.close();
    super.dispose();
  }
}