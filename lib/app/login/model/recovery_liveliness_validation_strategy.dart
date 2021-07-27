import 'dart:io';

import 'package:moniepoint_flutter/app/liveliness/model/strategy/liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:path_provider/path_provider.dart';


class RecoveryLivelinessValidationStrategy extends LivelinessValidationStrategy <RecoveryResponse>{

  final Map<String, dynamic> arguments;
  final LivelinessVerificationViewModel viewModel;

  RecoveryLivelinessValidationStrategy(this.viewModel, this.arguments) : super(viewModel);

  @override
  Future<RecoveryResponse?> validate(String firstCapturePath, String motionCapturePath) async {
    //TODO handle both username and password recovery
    final bvn = arguments["bvn"];
    final phoneNumberValidationKey = arguments["phoneNumberValidationKey"];
    final cacheDir = await getTemporaryDirectory();
    final firstCaptureFile = File(firstCapturePath);
    final motionCaptureFile = File(motionCapturePath);

    final response = viewModel.validateForRecovery(firstCaptureFile, motionCaptureFile, ForgotPasswordRequest());
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
    throw UnimplementedError();
  }

}