
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/login/model/data/fingerprint_login_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/login_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/password_login_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/app/login/model/login_service.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class LoginServiceDelegate with NetworkResource{
  late final LoginService _service;

  LoginServiceDelegate(LoginService service) {
    this._service = service;
  }

  void _updateSession(User user) {
    UserInstance().setUser(user);
    final userAccounts = user.customers?.first.customerAccountUsers?.map((e) {
      return UserAccount(
          id: e.customerAccount?.id,
          customerAccount: e.customerAccount,
          customer: e.customerAccount?.customer,
          accountProvider: e.customerAccount?.schemeCode?.accountProvider
      );
    }).toList() ?? [];
    UserInstance().setUserAccounts(userAccounts);
  }

  Stream<Resource<User>> loginWithPassword(LoginRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.loginWithPassword(requestBody as LoginWithPasswordRequestBody),
        saveRemoteData: (user) async {
          _updateSession(user);
        }
    );
  }

  Stream<Resource<User>> loginWithFingerprint(LoginRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.loginWithFingerprint(requestBody as LoginWithFingerprintRequestBody),
        saveRemoteData: (user) async {
          _updateSession(user);
        }
    );
  }
}