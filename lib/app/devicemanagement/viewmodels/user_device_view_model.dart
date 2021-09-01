
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/user_device.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/user_device_request_body.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/user_device_service_delegate.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/device_manager.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class UserDeviceViewModel extends BaseViewModel{

  late final UserDeviceServiceDelegate _delegate;
  late final DeviceManager _deviceManager;

  UserDeviceViewModel({UserDeviceServiceDelegate? delegate, DeviceManager? deviceManager}) {
    this._delegate = delegate ?? GetIt.I<UserDeviceServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
  }

  Stream<Resource<List<UserDevice>>> getUserDevices(String username) {
    return _delegate.getUserDevices(username);
  }

  Stream<Resource<bool>> deleteUserDevice(UserDevice userDevice, String pin) {
    return _delegate.deleteUserDevice(UserDeviceRequestBody(
        username: PreferenceUtil.getSavedUsername() ?? "",
        deviceId: userDevice.deviceId,
        deviceName: userDevice.name,
        transactionPin: pin
    ));
  }

  String? getCurrentDeviceId() {
    return _deviceManager.deviceId;
  }

}