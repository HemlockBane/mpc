import 'package:moniepoint_flutter/app/devicemanagement/model/data/user_device_request_body.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/user_device_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/user_device.dart';

class UserDeviceServiceDelegate with NetworkResource {
  late final UserDeviceService _service;

  UserDeviceServiceDelegate(UserDeviceService service) {
    this._service = service;
  }

  Stream<Resource<List<UserDevice>>> getUserDevices(String username) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.getUserDevices(UserDeviceRequestBody(username: username))
    );
  }

  Stream<Resource<bool>> deleteUserDevice(UserDeviceRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.deleteUserDevice(requestBody)
    );
  }

}
