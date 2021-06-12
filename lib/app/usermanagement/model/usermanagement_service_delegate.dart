import 'package:moniepoint_flutter/app/usermanagement/model/data/change_password_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/change_pin_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/finger_print_auth_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';


class UserManagementServiceDelegate with NetworkResource {
  late final UserManagementService _service;

  UserManagementServiceDelegate(UserManagementService service) {
    this._service = service;
  }

  Stream<Resource<RecoveryResponse>> forgotUsername(ForgotPasswordRequest requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.forgotUsername(requestBody)
    );
  }

  Stream<Resource<RecoveryResponse>> forgotPassword(ForgotPasswordRequest requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.forgotPassword(requestBody)
    );
  }

  Stream<Resource<OTP>> sendForgotUsernameOtp(ForgotPasswordRequest requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.sendForgotUsernameOtp(requestBody)
    );
  }

  Stream<Resource<OTP>> sendForgotPasswordOtp(ForgotPasswordRequest requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.sendForgotPasswordOtp(requestBody)
    );
  }

  Stream<Resource<bool>> changePassword(ChangePasswordRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.changePassword(requestBody)
    );
  }

  Stream<Resource<bool>> changePin(ChangePinRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.changeTransactionPin(requestBody)
    );
  }

  Stream<Resource<bool>> setFingerPrint(FingerPrintAuthRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.setFingerprint(requestBody)
    );
  }
}