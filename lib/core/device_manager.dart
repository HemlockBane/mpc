import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:get_it/get_it.dart';

class DeviceManager {

  String? _deviceName;
  String? get deviceName => _deviceName;

  String? _deviceId;
  String? get deviceId => _deviceId;

  static DeviceManager? _deviceManager;

  DeviceManager._internal() {
    _init();
  }

  void _init() async {
    var deviceManager = GetIt.I<DeviceInfoPlugin>();
    if(Platform.isAndroid) {
      deviceManager.androidInfo.then((value) {
        _deviceId = value.androidId;
        _deviceName = value.device;
      });
    } else if(Platform.isIOS) {
      deviceManager.iosInfo.then((value) {
        _deviceId = value.identifierForVendor;
        _deviceName = value.name;
      });
    }
  }

  factory DeviceManager() => _deviceManager ?? DeviceManager._internal();
}