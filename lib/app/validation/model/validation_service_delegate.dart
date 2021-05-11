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

  Stream<Resource<ValidateAnswerResponse>> validateSecurityQuestionAnswer(SecurityQuestionRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.validateUsernameSecurityAnswer(requestBody)
    );
  }

  Stream<Resource<OTP>> triggerOtpForEditDevice(TriggerOtpRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.triggerOTP(requestBody)
    );
  }

  Stream<Resource<ValidateAnswerResponse>> validateEditDeviceOtp(ValidateDeviceSwitchRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.validateOtp(requestBody),
        processRemoteResponse: (resp) {
          String? accessToken = resp.data?.result?.accessToken;
          if (accessToken != null && accessToken.isNotEmpty)
            UserInstance().getUser()!.withAccessToken(accessToken);
        }
    );
  }

  Stream<Resource<bool>> editDevice(EditDeviceRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.editDevice(requestBody)
    );
  }

}