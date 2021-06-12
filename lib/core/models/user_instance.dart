import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/timeout_reason.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

class UserInstance {
  static UserInstance? _instance;
  static User? _user;
  static AccountStatus? _accountStatus;
  static Timer? timer;

  UserInstance._internal() {
    _instance = this;
  }

  factory UserInstance() => _instance ?? UserInstance._internal();

  void setUser(User user) {
    _user = user;
  }

  User? getUser() {
    if(_user == null) _user = PreferenceUtil.getLoggedInUser();
    return _user;
  }

  void setAccountStatus(AccountStatus accountStatus) {
    _accountStatus = accountStatus;
  }

  AccountStatus? get accountStatus => _accountStatus;

  void _sessionTimeOut(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(
        Routes.LOGIN, (route) => false,
        arguments: Tuple("reason", SessionTimeoutReason.INACTIVITY)
    );
  }

  void  startSession(BuildContext context) {
    timer?.cancel();
    timer = Timer(Duration(seconds: 120), () => _sessionTimeOut(context));
  }
}