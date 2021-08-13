
import 'dart:io';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'liveliness_validation_strategy.dart';
/// @author Paul Okeke
class OnboardingLivelinessValidationStrategy extends LivelinessValidationStrategy<OnboardingLivelinessValidationResponse>{

  final Map<String, dynamic> arguments;
  final LivelinessVerificationViewModel viewModel;

  OnboardingLivelinessValidationStrategy(this.viewModel, this.arguments) : super(viewModel);

  @override
  Future<OnboardingLivelinessValidationResponse?> validate(String firstCapturePath, String motionCapturePath) async {
    final bvn = arguments["bvn"];
    final phoneNumberValidationKey = arguments["phoneNumberValidationKey"];

    final response = viewModel.validateLivelinessForOnboarding(File(firstCapturePath), File(motionCapturePath), bvn, phoneNumberValidationKey);
    OnboardingLivelinessValidationResponse? returnValue;

    await for (var value in response) {
      if(value is Success) {
        returnValue = value.data;
      }
      if(value is Error<OnboardingLivelinessValidationResponse>) {
        throw Exception(value.message);
      }
    }
    return returnValue;
  }

}