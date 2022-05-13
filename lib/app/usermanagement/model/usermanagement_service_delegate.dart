import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/change_password_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/change_pin_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/finger_print_auth_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';

import 'data/reset_otp_validation_response.dart';
import 'data/reset_pin_liveliness_validation_response.dart';
import 'data/reset_pin_response.dart';


class UserManagementServiceDelegate with NetworkResource {
  late final UserManagementService _service;

  UserManagementServiceDelegate(UserManagementService service) {
    this._service = service;
  }

  Stream<Resource<RecoveryResponse>> forgotUsername(
      ForgotPasswordRequest requestBody,
      {File? firstCapture,
      File? motionCapture}) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () {
          return this._service.forgotUsername(
              describeEnum(requestBody.step ?? ForgotPasswordStep.INITIATE),
              requestBody.key,
              otp: requestBody.otp,
              userCode: requestBody.otpUserCode,
              otpValidationKey: requestBody.otpValidationKey,
              firstCapture: firstCapture,
              motionCapture: motionCapture);
        });
  }

  Stream<Resource<RecoveryResponse>> forgotPassword(ForgotPasswordRequest requestBody, {File? firstCapture,
    File? motionCapture}) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () {
          return this._service.forgotPassword(
            describeEnum(requestBody.step ?? ForgotPasswordStep.INITIATE),
            requestBody.username,
              otp: requestBody.otp,
              userCode: requestBody.otpUserCode,
              otpValidationKey: requestBody.otpValidationKey,
              livelinessCheckRef: requestBody.livelinessCheckRef,
              password: requestBody.password,
              firstCapture: firstCapture,
              motionCapture: motionCapture
          );
        }
    );
  }

  Stream<Resource<bool>> completeForgotPassword(ForgotPasswordRequest requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () {
          return this._service.completeForgotPassword(
              describeEnum(requestBody.step ?? ForgotPasswordStep.INITIATE),
              requestBody.username,
              livelinessCheckRef: requestBody.livelinessCheckRef,
              password: requestBody.password,
          );
        }
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

  Stream<Resource<OTP?>> triggerOtpForPinReset() {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.triggerOtpForPinReset()
    );
  }

  Stream<Resource<ResetOtpValidationResponse>> validateOtpForPinReset(String otp) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.validateOtpForPinReset({
          "otp": otp
        })
    );
  }

  Stream<Resource<ResetPinLivelinessValidationResponse?>>
      validateLivelinessForPinReset(
          File firstCapture, File secondCapture, String key) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this
            ._service
            .validateLivelinessForPinReset(firstCapture, secondCapture, key));
  }

  Stream<Resource<ResetPINResponse?>> resetPin(String pin, String livelinessKey) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.resetTransactionPin({
          "livelinessValidationKey": livelinessKey,
          "pin": pin
        })
    );
  }

  Stream<Resource<bool>> setFingerPrint(FingerPrintAuthRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.setFingerprint(requestBody)
    );
  }


}