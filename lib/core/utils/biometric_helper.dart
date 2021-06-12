import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/core/tuple.dart';

class BiometricHelper {

  static const _platform = const MethodChannel('moniepoint.flutter.dev/biometric');
  static const _eventChannel = const EventChannel('moniepoint.flutter.dev/biometric_auth');

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
    if(Platform.isIOS) return false;
    final isInitialized = await _platform.invokeMethod("initialize", {
      "keyFileName": keyFileName,
      "keyStoreName": keyStoreName,
      "keyAlias": keyAlias,
    });
    return (isInitialized is bool && isInitialized) ? isInitialized : false;
  }

  Future<Tuple<bool, String?>> isFingerPrintAvailable() async {
    if(Platform.isIOS) return Tuple(false, "Currently Not Supported");
    final mapResult = await _platform.invokeMethod("isFingerPrintAvailable");
    final isAvailable = mapResult["availability"] ?? false;
    final extraMessage = mapResult["extra_message"] ?? null;
    return Tuple(isAvailable, extraMessage);
  }

  Future<String?> getFingerprintPassword() async {
    if (Platform.isIOS) return null;
    final stringResult = await _platform.invokeMethod("get_finger_print_password");
    return stringResult;
  }

  authenticate({Function(String? fingerprintKey, String? extraMessage)? authenticationCallback, String authType = "Login"}) {
    if (Platform.isIOS) return () => false;
    final subscription = _eventChannel.receiveBroadcastStream({"authType": authType}).listen((event) {
      authenticationCallback?.call(event["fingerPrintKey"], event["extraMessage"]);
    });
    return () => subscription.cancel();
  }

  Future<void> deleteFingerPrintPassword() async {
    if(Platform.isIOS) return ;
    await _platform.invokeMethod("remove_finger_print_password");
  }
}