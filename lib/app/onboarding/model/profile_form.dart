
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/profile_request.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:rxdart/rxdart.dart';

///
class ProfileForm with ChangeNotifier, Validators {

  late final Stream<bool> _isValid;
  var isUsernameVerified = false;

  final ProfileCreationRequestBody _requestBody = ProfileCreationRequestBody();
  ProfileCreationRequestBody get profile => _requestBody;

  final _usernameController = StreamController<String>.broadcast();
  Stream<String> get usernameStream => _usernameController.stream;

  final _passwordController = StreamController<String>.broadcast();
  Stream<String> get passwordStream => _passwordController.stream;

  ProfileForm() {
    _initState();
  }

  /// Initializes the state of the profile form
  void _initState() {
    this._isValid = Rx.combineLatest([usernameStream, passwordStream], (values) {
      return _isUsernameValid(displayError: false)
          && _isPasswordValid(displayError: false);
    });
  }

  void onUsernameChanged(String? text) {
    isUsernameVerified = false;
    _requestBody.username = text;
    _usernameController.sink.add(text ?? "");
    _isUsernameValid(displayError: true);
  }

  /// Validates the username
  /// The username is only valid after it's been verified from the backend
  bool _isUsernameValid({bool displayError = false}) {
    final isValid = _requestBody.username != null && _requestBody.username!.isNotEmpty;
    if (displayError && !isValid) _usernameController.addError("Enter username");
    return isValid && isUsernameVerified;
  }

  void onPasswordChanged(String? text) {
    _requestBody.password = text;
    _passwordController.sink.add(text ?? "");
    _isPasswordValid(displayError: true);
  }

  bool _isPasswordValid({bool displayError = false}) {
    final validator = validatePasswordWithMessage(_requestBody.password);
    if(validator.first) return true;
    if (displayError && !validator.first) _passwordController.sink.addError(validator.second ?? "");
    return false;
  }

  Stream<bool> get isValid => _isValid;

  @override
  void dispose() {
    _usernameController.close();
    _passwordController.close();
    super.dispose();
  }

}