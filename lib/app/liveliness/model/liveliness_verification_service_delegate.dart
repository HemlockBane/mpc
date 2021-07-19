
import 'dart:io';

import 'package:moniepoint_flutter/app/liveliness/model/onboarding_validation_service.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class LivelinessVerificationServiceDelegate with NetworkResource {
  late final OnboardingValidationService _onboardingValidationService;

  LivelinessVerificationServiceDelegate(
      OnboardingValidationService onboardingValidationService) {
    this._onboardingValidationService = onboardingValidationService;
  }

  Stream<Resource<OnboardingLivelinessValidationResponse>> validateLivelinessForOnboarding(
      File firstCapture, File motionCapture, String bvn, String phoneNumberValidationKey) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () {
          return this._onboardingValidationService.validateLivelinessForOnboarding(
              firstCapture, motionCapture, bvn, phoneNumberValidationKey
          );
        },
    );
  }
  
}