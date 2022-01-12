import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

enum BiometricType {
  FACE_ID, FINGER_PRINT, NONE
}

class BiometricHelper {

  static const _platform = const MethodChannel('moniepoint.flutter.dev/biometric');
  static const _eventChannel = const EventChannel('moniepoint.flutter.dev/biometric_auth');

  static const LoginAuthType = "Login";
  static const SetUpAuthType = "SetUp";

  static BiometricHelper? _biometricHelper;

  BiometricHelper();

  static Future<BiometricHelper> initialize({
    required String keyFileName,
    required String keyStoreName,
    required String keyAlias,
  }) async {
    await _initialize(keyFileName, keyStoreName, keyAlias);
    _biometricHelper = BiometricHelper();
    return _biometricHelper!;
  }

  static BiometricHelper getInstance() {
    if(_biometricHelper == null) throw Exception("Must Call initialize first");
    return _biometricHelper!;
  }

  static Future<bool> _initialize(String keyFileName, String keyStoreName, String keyAlias) async {
    if(Platform.isIOS) return true;
    final isInitialized = await _platform.invokeMethod("initialize", {
      "keyFileName": keyFileName,
      "keyStoreName": keyStoreName,
      "keyAlias": keyAlias,
    });
    return (isInitialized is bool && isInitialized) ? isInitialized : false;
  }

  Future<BiometricType> getBiometricType() async {
    final mapResult = await _platform.invokeMethod("get_biometric_type");
    final biometricTypeResult = mapResult["biometric_type"];
    final biometricType = BiometricType.values.firstWhere((element) => describeEnum(element) == biometricTypeResult, orElse: () => BiometricType.NONE);
    return biometricType;
  }

  Future<String?> getFingerprintPassword() async {
    if (Platform.isIOS) return PreferenceUtil.getFingerprintPassword();
    final stringResult = await _platform.invokeMethod("get_finger_print_password");
    return stringResult;
  }

  authenticate({Function(String? fingerprintKey, String? extraMessage)?authenticationCallback, String authType = "Login"}) {
    if (Platform.isIOS) {
      return _authenticateIOS(authenticationCallback: authenticationCallback, authType: authType);
    }
    return _authenticateAndroid(authenticationCallback: authenticationCallback, authType: authType);
  }

  _authenticateAndroid({Function(String? fingerprintKey, String? extraMessage)?authenticationCallback, String authType = "Login"}) {
    final subscription = _eventChannel.receiveBroadcastStream({"authType": authType}).listen((event) {
      authenticationCallback?.call(event["fingerPrintKey"], event["extraMessage"]);
    });
    return () => subscription.cancel();
  }

  String _createCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (index) => Random.secure().nextInt(256));
    return base64Url.encode(values);
  }

  _authenticateIOS({Function(String? fingerprintKey, String? extraMessage)?authenticationCallback, String authType = "Login"}) {
    String? encryptionKey = PreferenceUtil.getValueForLoggedInUser("encryption-key");

    if(encryptionKey == null) {
      encryptionKey = _createCryptoRandomString();
      PreferenceUtil.saveValueForLoggedInUser("encryption-key", encryptionKey);
    }

    final data = {"authType": authType, "encryptionKey": encryptionKey};

    if(authType == "SetUp") {

      String password = "moniepoint_generated";//useless

      data["username"] = PreferenceUtil.getSavedUsername()!;
      data["generated_password"] = password;

      _platform.invokeMethod("authenticate", data).then((event) {
        authenticationCallback?.call(event["passwordKey"], event["extraMessage"]);
        if(event["passwordKey"] != null) PreferenceUtil.setFingerprintPassword(password);
        print("Value ended ${event["passwordKey"]}");
      });
    } else {
      _platform.invokeMethod("authenticate", data).then((event) {
        authenticationCallback?.call(event["passwordKey"], event["extraMessage"]);
      });
    }
    return () => false;
  }

  Future<void> deleteFingerPrintPassword() async {
    if(Platform.isIOS) return PreferenceUtil.setFingerprintPassword(null);
    await _platform.invokeMethod("remove_finger_print_password");
  }
}