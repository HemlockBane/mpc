
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:path_provider/path_provider.dart';

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
    final cacheDir = await getTemporaryDirectory();
    final firstCaptureFile = await FlutterImageCompress.compressAndGetFile(firstCapturePath, "${cacheDir.path}/1_liveliness.jpg", quality: 75);
    final motionCaptureFile = await FlutterImageCompress.compressAndGetFile(motionCapturePath, "${cacheDir.path}/2_liveliness.jpg", quality: 75);

    final response = viewModel.validateLivelinessForOnboarding(firstCaptureFile!, motionCaptureFile!, bvn, phoneNumberValidationKey);
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