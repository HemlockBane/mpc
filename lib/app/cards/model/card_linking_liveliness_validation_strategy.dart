import 'dart:io';

import 'package:moniepoint_flutter/app/liveliness/model/strategy/liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/card_linking_response.dart';

class CardLinkingLivelinessValidationStrategy extends LivelinessValidationStrategy<CardLinkingResponse> {

  final Map<String, dynamic> arguments;
  final LivelinessVerificationViewModel viewModel;

  CardLinkingLivelinessValidationStrategy(this.viewModel, this.arguments) : super(viewModel);

  @override
  Future<CardLinkingResponse?> validate(String firstCapturePath, String motionCapturePath) async {
    final cardSerial = arguments["cardSerial"];
    final accountId = arguments["customerAccountId"];
    final otpValidationKey = arguments["otpValidationKey"];

    final response = viewModel.validateForCardLinking(
        File(firstCapturePath),
        File(motionCapturePath),
        cardSerial,
        "$accountId",
        otpValidationKey
    );

    CardLinkingResponse? returnValue;

    await for (var value in response) {
      if(value is Success) {
        returnValue = value.data;
      }
      if(value is Error<CardLinkingResponse>) {
        throw Exception(value.message);
      }
    }
    return returnValue;
  }

}