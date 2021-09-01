import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

final MethodChannel _iosDeviceChannel = const MethodChannel('moniepoint.flutter.dev/device_manager');

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
  
  Future<String?> _getPersistedDeviceId() {
    return _iosDeviceChannel.invokeMethod("get_device_id");
  }

  Future<bool?> _persistDeviceId(String deviceId) {
    return _iosDeviceChannel.invokeMethod("set_device_id", {"deviceId": deviceId});
  }

  void resetIosDeviceId(IosDeviceInfo deviceInfo) async {
    //So we need to check if we have the deviceId saved in the keychain
    //Because the identifierForVendor isn't retained during uninstalls and re-install
    //on a particular device, however the value on the keychain remains forever on the device
    //except for a hard factory reset though.
    final persistedDeviceId = await _getPersistedDeviceId();
    if(persistedDeviceId == null) {
      _deviceId = deviceInfo.identifierForVendor;
      if(_deviceId != null) {
        final isPersisted = await _persistDeviceId(_deviceId!);
        if(isPersisted == false) {
          //There's really nothing we can do here
          //because the reason why it wouldn't save in the first place
          //must have been dealt with
        }
      } else {
        //A very unlikely situation but there's a possibility that
        //the ios identifierForVendor returns nil. we simply have to wait and retry
        Future.delayed(Duration(seconds: 120), () {
          resetIosDeviceId(deviceInfo);
        });
      }
    } else {
      _deviceId = persistedDeviceId;
    }
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
      resetIosDeviceId(value);
      _deviceName = value.name;
      _deviceVersion = value.systemVersion;
      _deviceBrandName = value.localizedModel;
    }
    return;
  }

  factory DeviceManager() => _deviceManager ?? DeviceManager._internal();
}