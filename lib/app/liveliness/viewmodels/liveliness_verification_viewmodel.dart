

import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/liveliness/model/liveliness_verification_service_delegate.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class LivelinessVerificationViewModel extends BaseViewModel{

  late final LivelinessVerificationServiceDelegate _verificationServiceDelegate;
  late final UserManagementServiceDelegate _userServiceDelegate;

  LivelinessVerificationViewModel({
    LivelinessVerificationServiceDelegate? verificationServiceDelegate,
    UserManagementServiceDelegate? userManagementServiceDelegate
  }) {
    this._verificationServiceDelegate = verificationServiceDelegate ?? GetIt.I<LivelinessVerificationServiceDelegate>();
    this._userServiceDelegate = userManagementServiceDelegate ?? GetIt.I<UserManagementServiceDelegate>();
  }

  Stream<Resource<OnboardingLivelinessValidationResponse>> validateLivelinessForOnboarding(
      File firstCapture, File motionCapture, String bvn, String phoneNumberValidationKey) {
    return _verificationServiceDelegate.validateLivelinessForOnboarding(firstCapture, motionCapture, bvn, phoneNumberValidationKey);
  }

  Stream<Resource<RecoveryResponse>> validateForRecovery(
      File firstCapture, File motionCapture, ForgotPasswordRequest request) {
    return _userServiceDelegate.forgotUsername(request,
        firstCapture: firstCapture, motionCapture: motionCapture
    );
  }

}