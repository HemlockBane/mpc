import 'package:moniepoint_flutter/app/cards/model/card_activation_liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/cards/model/card_linking_liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_verification_for.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/app/login/model/device_liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/login/model/recovery_liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/strategy/reset_pin_validation_strategy.dart';

import 'onboarding_liveliness_validation_strategy.dart';

/// @author  Paul Okeke
abstract class LivelinessValidationStrategy<T extends LivelinessValidationResponse> {

  LivelinessValidationStrategy(LivelinessVerificationViewModel viewModel);

  Future<T?> validate(String firstCapturePath, String motionCapturePath);

  //TODO use this as a factory method for getting validation behavior for liveliness
  //TODO return a singleton instance
  factory LivelinessValidationStrategy.getInstance(LivelinessVerificationViewModel viewModel,
      LivelinessVerificationFor verificationFor, Map<String, dynamic> arguments) {

    LivelinessValidationStrategy strategy;

    switch(verificationFor) {
      case LivelinessVerificationFor.ON_BOARDING:
        strategy = OnboardingLivelinessValidationStrategy(viewModel, arguments);
        break;
      case LivelinessVerificationFor.USERNAME_RECOVERY:
        strategy = RecoveryLivelinessValidationStrategy(viewModel, arguments);
        break;
      case LivelinessVerificationFor.PASSWORD_RECOVERY:
        strategy = RecoveryLivelinessValidationStrategy(viewModel, arguments);
        break;
      case LivelinessVerificationFor.REGISTER_DEVICE:
        strategy = DeviceLivelinessValidationStrategy(viewModel, arguments);
        break;
      case LivelinessVerificationFor.CARD_LINKING:
        strategy = CardLinkingLivelinessValidationStrategy(viewModel, arguments);
        break;
      case LivelinessVerificationFor.CARD_ACTIVATION:
        strategy = CardActivationLivelinessValidationStrategy(viewModel, arguments);
        break;
      case LivelinessVerificationFor.PIN_RESET:
        strategy = ResetPinValidationStrategy(viewModel, arguments);
        break;
      default:
        strategy = OnboardingLivelinessValidationStrategy(viewModel, arguments);
    }

    return strategy as LivelinessValidationStrategy<T>;
  }

}