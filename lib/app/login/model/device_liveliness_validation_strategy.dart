import 'dart:io';

import 'package:moniepoint_flutter/app/liveliness/model/strategy/liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_answer_response.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';


class DeviceLivelinessValidationStrategy extends LivelinessValidationStrategy<ValidateAnswerResponse>{

  final Map<String, dynamic> arguments;
  final LivelinessVerificationViewModel viewModel;

  DeviceLivelinessValidationStrategy(this.viewModel, this.arguments) : super(viewModel);

  @override
  Future<ValidateAnswerResponse?> validate(String firstCapturePath, String motionCapturePath) async {
    final key = arguments["key"];
    final otpValidationKey = arguments["otpValidationKey"];

    final firstCaptureFile = File(firstCapturePath);
    final motionCaptureFile = File(motionCapturePath);

    final response = viewModel.validateLivelinessForRegisterDevice(
        firstCaptureFile, motionCaptureFile, otpValidationKey, key
    );

    ValidateAnswerResponse? returnValue;

    await for (var value in response) {
      if(value is Success) {
        returnValue = value.data;
      }
      if(value is Error<ValidateAnswerResponse>) {
        throw Exception(value.message);
      }
    }
    return returnValue;
  }

}