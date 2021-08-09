import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:get_it/get_it.dart';

class DeviceManager {

  String? _deviceName;
  String? get deviceName => _deviceName;

  String? _deviceId;
  String? get deviceId => _deviceId;

  String? _deviceVersion;
  String? get deviceVersion => _deviceVersion;

  String? _deviceBrandName;
  String? get deviceBrandName => _deviceBrandName;

  String? _deviceOs;
  String? get deviceOs => _deviceOs;

  static DeviceManager? _deviceManager;

  DeviceManager._internal() {
    init();
  }

  Future<void> init() async {
    var deviceManager = GetIt.I<DeviceInfoPlugin>();
    _deviceOs = Platform.isIOS ? "IOS" : "ANDROID";
    if(Platform.isAndroid) {
      final value = await deviceManager.androidInfo;
      _deviceId = value.androidId;
      _deviceName = value.device;
      _deviceVersion = value.version.codename;
      _deviceBrandName = value.brand;
    } else if(Platform.isIOS) {
      final value = await deviceManager.iosInfo;
      _deviceId = value.identifierForVendor;
      _deviceName = value.name;
      _deviceVersion = value.systemVersion;
      _deviceBrandName = value.localizedModel;
    }
    return;
  }

  factory DeviceManager() => _deviceManager ?? DeviceManager._internal();
}