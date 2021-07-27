import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_delegate.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/password_recovery_form.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/username_recovery_form.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/app/validation/model/data/authentication_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/edit_device_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/trigger_otp_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_answer_response.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_device_switch_request.dart';
import 'package:moniepoint_flutter/app/validation/model/validation_service_delegate.dart';
import 'package:moniepoint_flutter/core/device_manager.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';

class RecoveryViewModel extends ChangeNotifier {

  final userRecoveryForm = UsernameRecoveryForm();
  final passwordRecoveryForm = PasswordRecoveryForm();

  late UserManagementServiceDelegate _delegate;
  late SecurityQuestionDelegate questionDelegate;
  late ValidationServiceDelegate _validationDelegate;
  late DeviceManager _deviceManager;

  RecoveryMode? _recoveryMode;
  RecoveryMode? get recoveryMode => _recoveryMode;

  String? _validationKeyForDevice;
  String? _deviceOtpUserCode;
  String? _addDeviceKey;

  RecoveryViewModel({
    UserManagementServiceDelegate? delegate,
    SecurityQuestionDelegate? questionDelegate,
    ValidationServiceDelegate? validationDelegate,
    DeviceManager? deviceManager}) {
    this._delegate = delegate ?? GetIt.I<UserManagementServiceDelegate>();
    this.questionDelegate = questionDelegate ?? GetIt.I<SecurityQuestionDelegate>();
    this._validationDelegate = validationDelegate ?? GetIt.I<ValidationServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
  }

  void setRecoveryMode(RecoveryMode mode) {
    this._recoveryMode = mode;
  }

  ForgotPasswordRequest _getRequestData() {
    return (_recoveryMode == RecoveryMode.USERNAME_RECOVERY)
        ? userRecoveryForm.requestBody
        : passwordRecoveryForm.requestBody;
  }

  void setOtpCode(String? code) {
    _getRequestData().activationCode = code;
    _getRequestData().otp = code;
  }

  Stream<Resource<RecoveryResponse>> initiateRecovery() {
    final response = (_recoveryMode == RecoveryMode.USERNAME_RECOVERY)
        ? _delegate.forgotUsername(_getRequestData())
        : _delegate.forgotPassword(_getRequestData());

    return response.map((event) {
      if(event is Success) {
        _getRequestData().otpUserCode = event.data?.userCode;
      }
      return event;
    });
  }

  Stream<Resource<RecoveryResponse>> completeRecovery() {
    return (_recoveryMode == RecoveryMode.USERNAME_RECOVERY)
        ? _delegate.forgotUsername(_getRequestData()..withStep(ForgotPasswordStep.COMPLETE))
        : _delegate.forgotPassword(_getRequestData()..withStep(ForgotPasswordStep.COMPLETE));
  }


  Stream<Resource<RecoveryResponse>> validateOtp() {
    final response = (_recoveryMode == RecoveryMode.USERNAME_RECOVERY)
        ? _delegate.forgotUsername(_getRequestData()..withStep(ForgotPasswordStep.VALIDATE_OTP))
        : _delegate.forgotPassword(_getRequestData()..withStep(ForgotPasswordStep.VALIDATE_OTP));

    return response.map((event) {
      // if(event is Success) {
      //   _getRequestData().key = event.data?.key;
      // }
      return event;
    });
  }

  /// Used for edit device only
  Stream<Resource<OTP>> getOtpForDevice() {
    TriggerOtpRequestBody requestBody = TriggerOtpRequestBody()
      ..withUsername(UserInstance().getUser()?.username ?? "")
      ..customerType = "RETAIL"
      ..withValidationKey(_validationKeyForDevice ?? "");

    final response = _validationDelegate.triggerOtpForEditDevice(requestBody);
    return response.map((event) {
        _deviceOtpUserCode = event.data?.userCode;
      return event;
    });
  }

  /// Used for edit device only
  Stream<Resource<ValidateAnswerResponse>> validateDeviceOtp(String otpCode) {
    ValidateDeviceSwitchRequestBody requestBody =
        ValidateDeviceSwitchRequestBody()
          ..withUsername(UserInstance().getUser()?.username ?? "")
          ..customerType = "RETAIL"
          ..withRequest(AuthenticationRequest()
            ..userCode = _deviceOtpUserCode
            ..otp = otpCode
            ..authenticationType = "OTP")
          ..withValidationKey(_validationKeyForDevice ?? "");

    final response = _validationDelegate.validateEditDeviceOtp(requestBody);
    return response.map((event) {
      _addDeviceKey = event.data?.validationKey.key;
      return event;
    });
  }

  Stream<Resource<bool>> editDevice() {
    EditDeviceRequestBody requestBody = EditDeviceRequestBody()
    ..key = _addDeviceKey
    ..name = _deviceManager.deviceName
    ..deviceId = _deviceManager.deviceId;

    final response = _validationDelegate.editDevice(requestBody);
    return response.map((event) {
      return event;
    });
  }

  @override
  void dispose() {
    userRecoveryForm.dispose();
    passwordRecoveryForm.dispose();
    super.dispose();
  }
}