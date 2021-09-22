import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/finger_print_auth_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/device_manager.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class FingerPrintAlertViewModel extends BaseViewModel {
  late final UserManagementServiceDelegate _delegate;
  late final DeviceManager _deviceManager;

  FingerPrintAlertViewModel({UserManagementServiceDelegate? delegate, DeviceManager? deviceManager}) {
    this._delegate = delegate ?? GetIt.I<UserManagementServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
  }

  Stream<Resource<bool>> setFingerprint(String fingerPrintKey) {
    final requestBody = FingerPrintAuthRequestBody()
        .withDeviceId(_deviceManager.deviceId ?? "")
        .withFingerprintKey(fingerPrintKey);
    print(jsonEncode(requestBody));
    return _delegate.setFingerPrint(requestBody);
  }

  void removeFingerPrintKey(BiometricHelper biometricHelper) {
    biometricHelper.deleteFingerPrintPassword();
  }
}
