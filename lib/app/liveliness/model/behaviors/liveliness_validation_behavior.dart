import 'package:moniepoint_flutter/app/liveliness/liveliness_verification.dart';
import 'package:moniepoint_flutter/app/liveliness/model/behaviors/onboarding_liveliness_validation_behavior.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';

/// @author  Paul Okeke
abstract class LivelinessValidateBehavior<T> {

  LivelinessValidateBehavior(LivelinessVerificationViewModel viewModel);

  Future<T?> validate(String firstCapturePath, String motionCapturePath);

  //TODO use this as a factory method for getting validation behavior for liveliness
  factory LivelinessValidateBehavior.getInstance(LivelinessVerificationViewModel viewModel,
      LivelinessVerificationFor verificationFor, Map<String, dynamic> arguments) {
    return OnboardingLivelinessValidationBehavior(viewModel, arguments) as LivelinessValidateBehavior<T>;
  }

}