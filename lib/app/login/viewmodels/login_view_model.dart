
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/login/model/data/authentication_method.dart';
import 'package:moniepoint_flutter/app/login/model/data/fingerprint_login_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/login_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/password_login_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/app/login/model/login_service_delegate.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/device_manager.dart';
import 'package:moniepoint_flutter/core/models/services/system_configuration_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/system_configuration.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

class LoginViewModel with ChangeNotifier {

  late LoginServiceDelegate _delegate;
  late SystemConfigurationServiceDelegate _configurationServiceDelegate;
  late DeviceManager _deviceManager;

  final List<SystemConfiguration> _systemConfigurations = [];


  LoginViewModel({
    LoginServiceDelegate? delegate,
    SystemConfigurationServiceDelegate? configurationServiceDelegate,
    DeviceManager? deviceManager}) {
    this._delegate = delegate ?? GetIt.I<LoginServiceDelegate>();
    this._configurationServiceDelegate = configurationServiceDelegate ?? GetIt.I<SystemConfigurationServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();

    UserInstance().resetSession();
  }

  Stream<Resource<User>> loginWithPassword(String username, String password) {
    LoginWithPasswordRequestBody requestBody = LoginWithPasswordRequestBody()
      ..authenticationType = AuthenticationMethod.PASSWORD
      ..withUsername(username)
      ..withPassword(password)
      ..withVersion(BuildConfig.APP_VERSION)
      ..withDeviceId(_deviceManager.deviceId)
      // ..withDeviceId("9B234499-883D-4F4B-AAC4-F086867AEC46"/*_deviceManager.deviceId*/)
      // ..withDeviceId("7603883eb9cd8a8c"/*_deviceManager.deviceId*/)
      // ..withDeviceId("e4c6c4bcc9f9aedf"/*_deviceManager.deviceId*/)
      // ..withDeviceId("de961b69c51c1b85"/*_deviceManager.deviceId*/)
      ..withDeviceName(_deviceManager.deviceName);

    return doLogin(requestBody);
  }

  Stream<Resource<User>> loginWithFingerPrint(String fingerPrintPassword, String username) {
    final loginWithFingerprintRequestBody = LoginWithFingerprintRequestBody()
        ..authenticationType = AuthenticationMethod.FINGERPRINT
        ..withFingerprintKey(fingerPrintPassword)
        ..withDeviceId(_deviceManager.deviceId)
        ..withDeviceName(_deviceManager.deviceName)
        ..withVersion(BuildConfig.APP_VERSION)
        ..withUsername(username);
    return doLogin(loginWithFingerprintRequestBody);
  }

  Stream<Resource<User>> doLogin(LoginRequestBody requestBody) {
    UserInstance().resetSession();
    var response = (requestBody is LoginWithFingerprintRequestBody)
        ? _delegate.loginWithFingerprint(requestBody)
        : _delegate.loginWithPassword(requestBody);

    return response.map((event) {
      User? user = event.data;
      if(user == null) return event;
      return event;
    });
  }

  String getApplicationPlayStoreUrl() {
    final key = (Platform.isIOS) ? "ios.appstore.url" : "android.playstore.url";
    final config  = _systemConfigurations.firstWhere(
        (element) => element.name?.contains(key) == true,
        orElse: () => SystemConfiguration(value: "https://www.teamapt.com")
    );
    return config.value ?? "";
  }

  Stream<Resource<List<SystemConfiguration>>> getSystemConfigurations()  {
    return _configurationServiceDelegate.getSystemConfigurations(forceRemote: false).map((event) {
      if(event.data?.isNotEmpty == true) {
        _systemConfigurations.clear();
        _systemConfigurations.addAll(event.data ?? []);
      }
      return event;
    });
  }

  Future<bool> canLoginWithBiometric(BiometricHelper? _helper) async {
    final hasFingerPrint = (await _helper?.getFingerprintPassword()) != null;
    final biometricType = await _helper?.getBiometricType();
    final isEnabled = PreferenceUtil.getFingerPrintEnabled();
    return hasFingerPrint && (biometricType != BiometricType.NONE) && isEnabled;
  }

  @override
  void dispose() {
    super.dispose();
  }

}
