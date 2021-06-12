import 'dart:collection';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/login/model/data/authentication_method.dart';
import 'package:moniepoint_flutter/app/login/model/data/fingerprint_login_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/login_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/password_login_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/security_flag.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/app/login/model/login_service_delegate.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/device_manager.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

class LoginViewModel with ChangeNotifier {

  late LoginServiceDelegate _delegate;
  late DeviceManager _deviceManager;


  Queue<SecurityFlag>? _securityFlagQueue;
  Queue<SecurityFlag>? get securityFlagQueue => _securityFlagQueue;

  LoginViewModel({
    LoginServiceDelegate? delegate,
    DeviceManager? deviceManager}) {
    this._delegate = delegate ?? GetIt.I<LoginServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
    // _initDeviceManager();

    PreferenceUtil.deleteLoggedInUser();
    UserInstance().getUser()?.withAccessToken(null);
  }

  //334FD601-3E95-457E-B890-70BCD77B6F76
  Stream<Resource<User>> loginWithPassword(String username, String password) {
    LoginWithPasswordRequestBody requestBody = LoginWithPasswordRequestBody()
      ..authenticationType = AuthenticationMethod.PASSWORD
      ..withUsername(username)
      ..withPassword(password)
      ..withVersion(BuildConfig.APP_VERSION)
      ..withDeviceId(_deviceManager.deviceId ?? "")
      ..withDeviceName(_deviceManager.deviceName);

    return doLogin(requestBody);
  }

  Stream<Resource<User>> loginWithFingerPrint(String fingerPrintPassword, String username) {
    final loginWithFingerprintRequestBody = LoginWithFingerprintRequestBody()
        ..authenticationType = AuthenticationMethod.FINGERPRINT
        ..withFingerprintKey(fingerPrintPassword)
        .withDeviceId(_deviceManager.deviceId)
        .withDeviceName(_deviceManager.deviceName)
        .withVersion(BuildConfig.APP_VERSION)
        .withUsername(username);
    return doLogin(loginWithFingerprintRequestBody);
  }

  Stream<Resource<User>> doLogin(LoginRequestBody requestBody) {
    var response = (requestBody is LoginWithFingerprintRequestBody)
        ? _delegate.loginWithFingerprint(requestBody)
        : _delegate.loginWithPassword(requestBody);

    return response.map((event) {
      User? user = event.data;
      if(user == null) return event;

      _securityFlagQueue = user.securityFlags?.requiredFlagToQueue();

      return event;
    });
  }

}