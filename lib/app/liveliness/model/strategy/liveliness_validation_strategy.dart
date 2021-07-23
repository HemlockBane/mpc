import 'package:moniepoint_flutter/app/liveliness/liveliness_verification.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';

import 'onboarding_liveliness_validation_strategy.dart';

/// @author  Paul Okeke
abstract class LivelinessValidationStrategy<T> {

  LivelinessValidationStrategy(LivelinessVerificationViewModel viewModel);

  Future<T?> validate(String firstCapturePath, String motionCapturePath);

  //TODO use this as a factory method for getting validation behavior for liveliness
  factory LivelinessValidationStrategy.getInstance(LivelinessVerificationViewModel viewModel,
      LivelinessVerificationFor verificationFor, Map<String, dynamic> arguments) {
    return OnboardingLivelinessValidationStrategy(viewModel, arguments) as LivelinessValidationStrategy<T>;
  }

}