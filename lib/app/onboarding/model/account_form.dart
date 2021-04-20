import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_request.dart';
import 'package:moniepoint_flutter/core/models/gender.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:rxdart/rxdart.dart';


class AccountForm with ChangeNotifier, Validators{
  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;

  final _dobStreamController = StreamController<bool>.broadcast();
  Stream<bool> get dobStream => _dobStreamController.stream;

  final AccountCreationRequestBody _requestBody = AccountCreationRequestBody();

  AccountCreationRequestBody get account => _requestBody;

  final _bvnController = StreamController<String>.broadcast();
  Stream<String> get bvnStream => _bvnController.stream;

  final _phoneNumberController = StreamController<String>.broadcast();
  Stream<String> get phoneNumberStream => _phoneNumberController.stream;

  final _emailController = StreamController<String>.broadcast();
  Stream<String> get emailStream => _emailController.stream;

  final _genderController = StreamController<String>.broadcast();
  Stream<String> get genderStream => _genderController.stream;

  AccountForm() {
    _initState();
  }

  void _initState() {
    final formStreams = [
      bvnStream,
      phoneNumberStream,
      emailStream,
      genderStream
    ];

    this._isValid = Rx.combineLatest(formStreams, (values) {
      return _isBVNValid(displayError: false)
          && _isPhoneNumberValid(displayError: false)
          && _isEmailAddressValid(displayError: false)
          && _isGenderValid(displayError: false);
    });
  }


  void onBVNChanged(String? text) {
    _requestBody.bvn = text;
    _bvnController.sink.add(text ?? '');
    _isBVNValid(displayError: true);
  }

  bool _isBVNValid({bool displayError = false}) {
    final isValid = isBVNValid(_requestBody.bvn);
    if (displayError && !isValid) {
      _bvnController.sink.addError(
          (_requestBody.bvn == null || _requestBody.bvn!.isEmpty)
              ? 'BVN is required'
              : 'Invalid BVN');
    }
    return isValid;
  }

  void onPhoneNumberChanged(String? text) {
    _requestBody.phoneNumber = text;
    _phoneNumberController.sink.add(text ?? '');
    _isPhoneNumberValid(displayError: true);
  }

  bool _isPhoneNumberValid({bool displayError = false}) {
    final isValid = isPhoneNumberValid(_requestBody.phoneNumber);
    if (displayError && !isValid) {
      _phoneNumberController.sink.addError(
          (_requestBody.phoneNumber == null || _requestBody.phoneNumber!.isEmpty)
              ? 'Phone number is required'
              : 'Invalid Phone number');
    }
    return isValid;
  }

  void onEmailChanged(String? text) {
    _requestBody.emailAddress = text;
    _emailController.sink.add(text ?? '');
    _isEmailAddressValid(displayError: true);
  }

  bool _isEmailAddressValid({bool displayError = false}) {
    final isValid = isEmailValid(_requestBody.emailAddress);
    if (displayError && !isValid) {
      _emailController.sink.addError(
          (_requestBody.emailAddress == null || _requestBody.emailAddress!.isEmpty)
              ? 'Email address is required'
              : 'Invalid Email address');
    }
    return isValid;
  }

  void onGenderChanged(String? text) {
    _requestBody.gender = Gender.values.firstWhere((e) => e.toString() == 'Gender.'+ text!);
    _genderController.sink.add(text ?? '');
    _isGenderValid(displayError: true);
  }

  bool _isGenderValid({bool displayError = false}) {
    final isValid = _requestBody.gender != null;
    if (displayError && !isValid) {
      _genderController.sink.addError(
          (_requestBody.gender == null)
              ? 'Email address is required'
              : 'Invalid Gender');//never
    }
    return isValid;
  }

  void onDateOfBirthChanged(String? dateOfBirth) {
    _requestBody.dateOfBirth = dateOfBirth;
    _dobStreamController.sink.add(dateOfBirth != null && dateOfBirth.isNotEmpty);
  }
  
  @override
  void dispose() {
    _bvnController.close();
    _phoneNumberController.close();
    _emailController.close();
    _genderController.close();
    _dobStreamController.close();
    super.dispose();
  }

}