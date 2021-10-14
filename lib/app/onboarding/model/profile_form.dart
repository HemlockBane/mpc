import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/profile_request.dart';
import 'package:moniepoint_flutter/app/onboarding/username_validation_state.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:rxdart/rxdart.dart';

/// @author Paul Okeke
class ProfileForm with ChangeNotifier, Validators {

  Stream<bool>? _isValid;
  var isUsernameVerified = false;

  ProfileCreationRequestBody _requestBody = ProfileCreationRequestBody();
  ProfileCreationRequestBody get profile => _requestBody;

  final _usernameController = StreamController<Tuple<String, UsernameValidationState>>.broadcast();
  Stream<Tuple<String, UsernameValidationState>> get usernameStream => _usernameController.stream;

  final _passwordController = StreamController<String>.broadcast();
  Stream<String> get passwordStream => _passwordController.stream;

  final _pinInputController = StreamController<String>.broadcast();
  Stream<String> get pinInputStream => _pinInputController.stream;

  final _ussdPinInputController = StreamController<String>.broadcast();
  Stream<String> get ussdPinInputStream => _ussdPinInputController.stream;

  final _enableUssdPinController = StreamController<bool>.broadcast();
  Stream<bool> get enableUssdStream => _enableUssdPinController.stream;

  final _signatureController = StreamController<bool>.broadcast();
  Stream<bool> get signatureStream => _signatureController.stream;

  final _emailController = StreamController<String>.broadcast();
  Stream<String> get emailStream => _emailController.stream;

  bool _hasSignature = false;

  SetupType _setupType = SetupType();
  SetupType get setupType => _setupType;

  UsernameValidationState _validationState = UsernameValidationState(UsernameValidationStatus.NONE, "");

  ProfileForm();

  void setRequestBody(ProfileCreationRequestBody requestBody) {
    this._requestBody = requestBody;
  }

  void initForm() {
    final formStreams = [
      usernameStream,
      passwordStream,
      pinInputStream,
      signatureStream,
      enableUssdStream,
      ussdPinInputStream,
    ];

    if(setupType.hasEmail == false) formStreams.add(emailStream);

    this._isValid = Rx.combineLatest(formStreams, (values) {
      print(values);
      return _isUsernameValid(displayError: false)
          && _isPasswordValid(displayError: false)
          && _isPinValid(displayError: false)
          && _isUssdPinValid(displayError: false)
          && _isEmailAddressValid(displayError: false)
          && _validationState.status == UsernameValidationStatus.AVAILABLE
          && _hasSignature;
    }).asBroadcastStream();
  }

  void onUsernameChanged(String? text) {
    isUsernameVerified = false;
    _requestBody.username = text;
    this._validationState =  UsernameValidationState(UsernameValidationStatus.NONE, "");
    _usernameController.sink.add(Tuple(text ?? "", _validationState));
    _isUsernameValid(displayError: true);
  }

  void updateUsernameValidationState(UsernameValidationState state) {
    this._validationState = state;
    if(state.status == UsernameValidationStatus.FAILED || state.status == UsernameValidationStatus.ALREADY_TAKEN) {
      return _usernameController.sink.addError(state.message);
    }
    _usernameController.sink.add(Tuple(_requestBody.username ?? "", state));
  }

  /// Validates the username
  /// The username is only valid after it's been verified from the backend
  bool _isUsernameValid({bool displayError = false}) {
    final isValid = _requestBody.username != null && _requestBody.username!.isNotEmpty;
    if (displayError && !isValid) _usernameController.addError("Enter username");
    return isValid && true;
  }

  void onPasswordChanged(String? text) {
    _requestBody.password = text;
    _passwordController.sink.add(text ?? "");
    _isPasswordValid(displayError: true);
  }

  bool _isPasswordValid({bool displayError = false}) {
    final validator = validatePasswordWithMessage(_requestBody.password);
    if (validator.first) return true;
    if (displayError && !validator.first) _passwordController.sink.addError(validator.second?.first ?? "");
    return false;
  }

  void onPinChanged(String? text) {
    _requestBody.pin = text;
    _pinInputController.sink.add(text ?? "");
    _isPinValid(displayError: true);
  }

  bool _isPinValid({bool displayError = false}) {
    final pin = _requestBody.pin;
    final isValid = pin != null && pin.isNotEmpty && pin.length >= 4;
    if(isValid) FocusManager.instance.primaryFocus?.unfocus();
    if (displayError && !isValid) _pinInputController.sink.addError("Invalid PIN");
    return isValid;
  }

  void onUssdPinChanged(String? text) {
    (_requestBody as AccountCreationRequestBody).ussdPin = text;
    _ussdPinInputController.sink.add(text ?? "");
    _isUssdPinValid(displayError: true);
  }

  bool _isUssdPinValid({bool displayError = false}) {
    final requestBody = (_requestBody as AccountCreationRequestBody);
    if(requestBody.createUssdPin == false) return true;
    final pin = requestBody.ussdPin;
    final isValid = pin != null && pin.isNotEmpty && pin.length >= 4;
    if (isValid) FocusManager.instance.primaryFocus?.unfocus();
    if (displayError && !isValid) _ussdPinInputController.sink.addError("Invalid PIN");
    return isValid;
  }

  void onEmailChanged(String? text) {
    _requestBody.emailAddress = text;
    _emailController.sink.add(text ?? '');
    _isEmailAddressValid(displayError: true);
  }

  bool _isEmailAddressValid({bool displayError = false}) {
    if(setupType.hasEmail == true) return true;
    final isValid = isEmailValid(_requestBody.emailAddress);
    if (displayError && !isValid) {
      _emailController.sink.addError(
          (_requestBody.emailAddress == null || _requestBody.emailAddress!.isEmpty)
              ? 'Email address is required'
              : 'Invalid Email address');
    }
    return isValid;
  }

  void onEnableUssd(bool enable) {
    final requestBody = (_requestBody as AccountCreationRequestBody);
    requestBody.createUssdPin = enable;
    _enableUssdPinController.sink.add(enable);
    if(!enable) {
      _ussdPinInputController.sink.add("");
      requestBody.withUSSDPin("");
    }
  }

  void setHasSignature(bool hasSignature) {
    this._hasSignature = hasSignature;
    _signatureController.sink.add(hasSignature);
  }

  void setProfileSetupType(SetupType setupType) {
    this._setupType = setupType;
  }

  Stream<bool> get isValid => _isValid ?? Stream.value(false);

  @override
  void dispose() {
    _usernameController.close();
    _passwordController.close();
    _pinInputController.close();
    _ussdPinInputController.close();
    _enableUssdPinController.close();
    _signatureController.close();
    _emailController.close();
    super.dispose();
  }
}
