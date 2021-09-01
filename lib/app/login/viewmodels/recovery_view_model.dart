import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_delegate.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/password_recovery_form.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/username_recovery_form.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/app/validation/model/data/edit_device_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/trigger_otp_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_answer_response.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_device_switch_request.dart';
import 'package:moniepoint_flutter/app/validation/model/validation_service_delegate.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/device_manager.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';

class RecoveryViewModel extends ChangeNotifier {

  final userRecoveryForm = UsernameRecoveryForm();
  final passwordRecoveryForm = PasswordRecoveryForm();

  late UserManagementServiceDelegate _delegate;
  late SecurityQuestionDelegate questionDelegate;
  late ValidationServiceDelegate _validationDelegate;
  late DeviceManager _deviceManager;

  RecoveryMode? _recoveryMode;
  RecoveryMode? get recoveryMode => _recoveryMode;

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
    _getRequestData().otp = code;
  }

  void setLivelinessCheckRef(String? livelinessCheckRef) {
    _getRequestData().livelinessCheckRef = livelinessCheckRef;
  }

  Stream<Resource<RecoveryResponse>> initiateRecovery() {
    final response = (_recoveryMode == RecoveryMode.USERNAME_RECOVERY)
        ? _delegate.forgotUsername(_getRequestData()..withStep(ForgotPasswordStep.INITIATE))
        : _delegate.forgotPassword(_getRequestData()..withStep(ForgotPasswordStep.INITIATE));

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
        : _delegate.completeForgotPassword(_getRequestData()..withStep(ForgotPasswordStep.COMPLETE)).map((event) {
          if(event is Loading) return Resource.loading(null);
          if(event is Error<bool>) return Resource.error(err: ServiceError(message: event.message ?? ""), data: null);
          return Resource.success(RecoveryResponse());
        });
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
      ..withUsername(UserInstance().getUser()?.username ?? "");

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
          ..withUserCode(_deviceOtpUserCode ?? "")
          ..withOtp(otpCode);

    final response = _validationDelegate.validateEditDeviceOtp(requestBody);
    return response.map((event) {
      _addDeviceKey = event.data?.validationKey;
      return event;
    });
  }

  Stream<Resource<bool>> registerDevice(String livelinessValidationKey) {
    EditDeviceRequestBody requestBody = EditDeviceRequestBody()
    ..username = UserInstance().getUser()?.username
    ..key = livelinessValidationKey
    ..name = _deviceManager.deviceName
    ..deviceId = _deviceManager.deviceId;

    final response = _validationDelegate.registerDevice(requestBody);
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