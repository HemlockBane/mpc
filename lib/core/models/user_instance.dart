import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/timeout_reason.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

class UserInstance {
  static UserInstance? _instance;
  static User? _user;
  static AccountStatus? _accountStatus;
  static List<AccountBalance?> _accountBalance = [];
  static List<UserAccount> _userAccounts = [];
  static Timer? timer;

  UserInstance._internal() {
    _instance = this;
  }

  factory UserInstance() => _instance ?? UserInstance._internal();

  void resetSession() {
    _user = null;
    _accountStatus = null;
    _accountBalance = [];
    _userAccounts = [];
    PreferenceUtil.deleteLoggedInUser();
  }

  void setUser(User user) {
    _user = user;
  }

  User? getUser() {
    if(_user == null) _user = PreferenceUtil.getLoggedInUser();
    return _user;
  }

  void setAccountStatus(AccountStatus? accountStatus) {
    _accountStatus = accountStatus;
  }

  AccountStatus? get accountStatus => _accountStatus;

  void setAccountBalance(List<AccountBalance?> accountBalance) {
    _accountBalance = accountBalance;
  }

  List<AccountBalance?> get accountBalance => _accountBalance;

  void setUserAccounts(List<UserAccount> userAccounts) {
    _userAccounts.clear();
    _userAccounts.addAll(userAccounts);

    _accountBalance.clear();
    _accountBalance.addAll(_userAccounts.map((e) => e.accountBalance));
  }

  List<UserAccount> get userAccounts => _userAccounts;

  void sessionTimeOut(BuildContext context, SessionTimeoutReason reason) {
    // if(ServiceConfig.ENV != "dev" && ServiceConfig.ENV != "live") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(
          Routes.LOGIN, (route) => false,
          arguments: Tuple("reason", reason)
      );
    // }
  }

  void  startSession(BuildContext context) {
    timer?.cancel();
    timer = Timer(Duration(seconds: 120), () => sessionTimeOut(context, SessionTimeoutReason.INACTIVITY));
  }
}