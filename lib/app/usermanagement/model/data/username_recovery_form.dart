import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:rxdart/rxdart.dart';

class UsernameRecoveryForm with ChangeNotifier, Validators {
  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;
  
  final _accountNumberController = StreamController<String>.broadcast();
  Stream<String> get accountNumberStream => _accountNumberController.stream;

  final _bvnController = StreamController<String>.broadcast();
  Stream<String> get bvnStream => _bvnController.stream;

  final _requestBody = ForgotPasswordRequest()..withStep(ForgotPasswordStep.INITIATE);
  ForgotPasswordRequest get requestBody  => _requestBody;

  UsernameRecoveryForm() {
    _initState();
  }

  void _initState() {
    this._isValid = Rx.combineLatest([accountNumberStream, bvnStream], (values) {
      return _isAccountNumberValid(displayError: false) && _isBVNValid(displayError: false);
    }).asBroadcastStream();
  }

  void onAccountNumberChanged(String? text) {
    _requestBody.accountNumber = text;
    _accountNumberController.sink.add(text ?? "");
    _isAccountNumberValid(displayError: true);
  }

  bool _isAccountNumberValid({bool displayError = false}) {
    final isValid = isAccountNumberValid(_requestBody.accountNumber);
    if (isValid) return true;
    if (displayError && !isValid) _accountNumberController.sink
        .addError(_requestBody.accountNumber?.isEmpty == true ? "Account number is required" : "Invalid Account Number");
    return false;
  }

  void onBVNChanged(String? text) {
    _requestBody.bvn = text;
    _bvnController.sink.add(text ?? "");
    _isBVNValid(displayError: true);
  }

  bool _isBVNValid({bool displayError = false}) {
    final isValid = isBVNValid(_requestBody.bvn);
    if (isValid) return true;
    if (displayError && !isValid) _bvnController.sink
        .addError(_requestBody.bvn?.isEmpty == true ? "BVN is required" : "Invalid BVN");
    return false;
  }

  @override
  void dispose() {
    _accountNumberController.close();
    _bvnController.close();
    super.dispose();
  }
}