

import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/liveliness/model/liveliness_verification_service_delegate.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class LivelinessVerificationViewModel extends BaseViewModel{

  late final LivelinessVerificationServiceDelegate _verificationServiceDelegate;

  LivelinessVerificationViewModel({LivelinessVerificationServiceDelegate? verificationServiceDelegate }) {
    this._verificationServiceDelegate = verificationServiceDelegate ?? GetIt.I<LivelinessVerificationServiceDelegate>();
  }

  Stream<Resource<OnboardingLivelinessValidationResponse>> validateLivelinessForOnboarding(
      File firstCapture, File motionCapture, String bvn, String phoneNumberValidationKey) {
    return _verificationServiceDelegate.validateLivelinessForOnboarding(firstCapture, motionCapture, bvn, phoneNumberValidationKey);
  }

}