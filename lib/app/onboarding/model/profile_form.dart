import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/profile_request.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:rxdart/rxdart.dart';

/// @author Paul Okeke
class ProfileForm with ChangeNotifier, Validators {
  late final Stream<bool> _isValid;
  var isUsernameVerified = false;

  ProfileCreationRequestBody _requestBody = ProfileCreationRequestBody();

  ProfileCreationRequestBody get profile => _requestBody;

  final _usernameController = StreamController<String>.broadcast();
  Stream<String> get usernameStream => _usernameController.stream;

  final _passwordController = StreamController<String>.broadcast();
  Stream<String> get passwordStream => _passwordController.stream;

  final _pinInputController = StreamController<String>.broadcast();
  Stream<String> get pinInputStream => _pinInputController.stream;

  final _questionOneController = StreamController<SecurityQuestion>.broadcast();
  Stream<SecurityQuestion> get questionOneStream => _questionOneController.stream;

  final _questionTwoController = StreamController<SecurityQuestion>.broadcast();
  Stream<SecurityQuestion> get questionTwoStream => _questionTwoController.stream;

  final _questionThreeController = StreamController<SecurityQuestion>.broadcast();
  Stream<SecurityQuestion> get questionThreeStream => _questionThreeController.stream;

  final _answerOneController = StreamController<String>.broadcast();
  Stream<String> get answerOneStream => _answerOneController.stream;

  final _answerTwoController = StreamController<String>.broadcast();
  Stream<String> get answerTwoStream => _answerTwoController.stream;

  final _answerThreeController = StreamController<String>.broadcast();
  Stream<String> get answerThreeStream => _answerThreeController.stream;

  SecurityQuestion? _securityOne;
  SecurityQuestion? get securityQuestionOne => _securityOne;

  SecurityQuestion? _securityTwo;
  SecurityQuestion? get securityQuestionTwo => _securityTwo;

  SecurityQuestion? _securityThree;
  SecurityQuestion? get securityQuestionThree => _securityThree;

  String? _answerOne;
  String? get answerOne => _answerOne;

  String? _answerTwo;
  String? get answerTwo => _answerTwo;

  String? _answerThree;
  String? get answerThree => _answerThree;

  ProfileForm() {
    _initState();
  }

  void setRequestBody(ProfileCreationRequestBody requestBody) {
    this._requestBody = requestBody;
  }

  /// Initializes the state of the profile form
  void _initState() {
    final formStreams = [
      usernameStream,
      passwordStream,
      pinInputStream,
      questionOneStream,
      questionTwoStream,
      questionThreeStream,
      answerOneStream,
      answerTwoStream,
      answerThreeStream
    ];
    
    this._isValid = Rx.combineLatest(formStreams, (values) {
      return _isUsernameValid(displayError: false)
          && _isPasswordValid(displayError: false)
          && _isPinValid(displayError: false)
          && _securityOne != null
          && _securityTwo != null
          && _securityThree != null
          && _answerOne != null && _answerOne?.isNotEmpty == true
          && _answerTwo != null && _answerTwo?.isNotEmpty == true
          && _answerThree != null && _answerThree?.isNotEmpty == true;
    }).asBroadcastStream();
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
    return isValid && true; //isUsernameVerified;
  }

  void onPasswordChanged(String? text) {
    _requestBody.password = text;
    _passwordController.sink.add(text ?? "");
    _isPasswordValid(displayError: true);
  }

  bool _isPasswordValid({bool displayError = false}) {
    final validator = validatePasswordWithMessage(_requestBody.password);
    if (validator.first) return true;
    if (displayError && !validator.first) _passwordController.sink.addError(validator.second ?? "");
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
    if (displayError && !isValid) _pinInputController.sink.addError("Invalid PIN");
    return isValid;
  }

  void onSecurityQuestionChange(int questionNumber, SecurityQuestion question) {
    if (question.isEnabled) return;

    if (questionNumber == 1) {
      //get the previous selected question disable it
      _securityOne?.isEnabled = false;
      _questionOneController.sink.add(question);
      _securityOne = question;
      _securityOne?.isEnabled = true;
    } else if (questionNumber == 2) {
      _securityTwo?.isEnabled = false;
      _questionTwoController.sink.add(question);
      _securityTwo = question;
      _securityTwo?.isEnabled = true;
    } else if (questionNumber == 3) {
      _securityThree?.isEnabled = false;
      _questionThreeController.sink.add(question);
      _securityThree = question;
      _securityThree?.isEnabled = true;
    }
  }

  void onAnswerChanged(int questionNumber, String? text) {
    StreamSink? sink;
    if (questionNumber == 1) {
      sink = _answerOneController.sink;
      _answerOne = text;
    } else if (questionNumber == 2) {
      sink = _answerTwoController.sink;
      _answerTwo = text;
    } else if (questionNumber == 3) {
      sink = _answerThreeController.sink;
      _answerThree = text;
    }
    sink?.add(text ?? "");

    if (text == null || text.isEmpty) {
      sink?.addError('Answer $questionNumber is required.');
    }
  }

  Stream<bool> get isValid => _isValid;

  @override
  void dispose() {
    _usernameController.close();
    _passwordController.close();
    _pinInputController.close();

    _questionOneController.close();
    _questionTwoController.close();
    _questionThreeController.close();
    
    _answerOneController.close();
    _answerTwoController.close();
    _answerThreeController.close();
    super.dispose();
  }
}
