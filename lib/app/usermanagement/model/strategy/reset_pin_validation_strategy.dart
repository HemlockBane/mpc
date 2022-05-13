import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/liveliness/model/strategy/liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/reset_pin_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class ResetPinValidationStrategy extends LivelinessValidationStrategy {

  final Map<String, dynamic> arguments;
  final LivelinessVerificationViewModel viewModel;

  ResetPinValidationStrategy(this.viewModel, this.arguments)
      : super(viewModel);

  @override
  Future<LivelinessValidationResponse?> validate(
      String firstCapturePath, String motionCapturePath) async {

    final otpValidationKey = arguments["otpValidationKey"];

    final firstCaptureFile = File(firstCapturePath);
    final motionCaptureFile = File(motionCapturePath);

    final service = GetIt.I<UserManagementServiceDelegate>();

    final response = service.validateLivelinessForPinReset(
        firstCaptureFile, motionCaptureFile, otpValidationKey);

    ResetPinLivelinessValidationResponse? returnValue;

    await for (var value in response) {
      if (value is Success) {
        returnValue = value.data;
      }
      if (value is Error<ResetPinLivelinessValidationResponse>) {
        throw Exception(value.message);
      }
    }

    return returnValue;
  }
}
