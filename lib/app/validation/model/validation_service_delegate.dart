import 'dart:io';

import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/edit_device_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/trigger_otp_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_device_switch_request.dart';
import 'package:moniepoint_flutter/app/validation/model/validation_service.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';

import 'data/validate_answer_response.dart';

class ValidationServiceDelegate with NetworkResource {
  late final ValidationService _service;

  ValidationServiceDelegate(ValidationService service) {
    this._service = service;
  }

  Stream<Resource<OTP>> triggerOtpForEditDevice(TriggerOtpRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.triggerOTP(requestBody.username ?? "")
    );
  }

  Stream<Resource<ValidateAnswerResponse>> validateEditDeviceOtp(ValidateDeviceSwitchRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.validateOtp(
            requestBody.username ?? "",
            requestBody.otp ?? "",
            requestBody.userCode ?? "",
        ),
    );
  }

  Stream<Resource<bool>> registerDevice(EditDeviceRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.editDevice(requestBody)
    );
  }

  Stream<Resource<ValidateAnswerResponse>> validateLivelinessForDevice(
      File firstCapture, File motionCapture, String validationKey, String username) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.validateLivelinessForDevice(
            firstCapture, motionCapture, validationKey, username
        ),
        processRemoteResponse: (resp) {
          String? accessToken = resp.data?.result?.accessToken;
          if (accessToken != null && accessToken.isNotEmpty)
            UserInstance().getUser()!.withAccessToken(accessToken);
        }
    );
  }

}