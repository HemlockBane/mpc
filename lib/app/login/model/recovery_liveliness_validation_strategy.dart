import 'dart:io';

import 'package:moniepoint_flutter/app/liveliness/liveliness_verification.dart';
import 'package:moniepoint_flutter/app/liveliness/model/strategy/liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';


class RecoveryLivelinessValidationStrategy extends LivelinessValidationStrategy <RecoveryResponse>{

  final Map<String, dynamic> arguments;
  final LivelinessVerificationViewModel viewModel;

  RecoveryLivelinessValidationStrategy(this.viewModel, this.arguments) : super(viewModel);

  @override
  Future<RecoveryResponse?> validate(String firstCapturePath, String motionCapturePath) async {
    final key = arguments["key"];
    final otpValidationKey = arguments["otpValidationKey"];
    final verificationFor = arguments["verificationFor"] as LivelinessVerificationFor;

    final firstCaptureFile = File(firstCapturePath);
    final motionCaptureFile = File(motionCapturePath);

    final request = ForgotPasswordRequest()
    ..otpValidationKey = otpValidationKey
    ..step = ForgotPasswordStep.LIVELINESS_CHECK
    ..livelinessVerificationFor = verificationFor;

    if(verificationFor == LivelinessVerificationFor.USERNAME_RECOVERY) {
      request.key = key;
    } else if(verificationFor == LivelinessVerificationFor.PASSWORD_RECOVERY) {
      request.username = key;
    }

    final response = viewModel.validateForRecovery(
        firstCaptureFile, motionCaptureFile, request
    );

    RecoveryResponse? returnValue;

    await for (var value in response) {
      if(value is Success) {
        returnValue = value.data;
      }
      if(value is Error<RecoveryResponse>) {
        throw Exception(value.message);
      }
    }
    return returnValue;
  }

}