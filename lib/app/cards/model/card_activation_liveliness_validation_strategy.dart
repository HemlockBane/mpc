import 'dart:io';

import 'package:moniepoint_flutter/app/liveliness/model/strategy/liveliness_validation_strategy.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/card_activation_response.dart';
import 'data/card_linking_response.dart';

class CardActivationLivelinessValidationStrategy extends LivelinessValidationStrategy<CardActivationResponse> {

  final Map<String, dynamic> arguments;
  final LivelinessVerificationViewModel viewModel;

  CardActivationLivelinessValidationStrategy(this.viewModel, this.arguments) : super(viewModel);

  @override
  Future<CardActivationResponse?> validate(String firstCapturePath, String motionCapturePath) async {
    final cvv2 = arguments["cvv2"];
    final newPin = arguments["newPin"];
    final cardId = arguments["cardId"];
    final accountId = arguments["customerAccountId"];

    final response = viewModel.validateCardForActivation(
        File(firstCapturePath),
        File(motionCapturePath),
        cardId ?? 0,
        cvv2,
        newPin,
        "$accountId"
    );

    CardActivationResponse? returnValue;

    await for (var value in response) {
      if(value is Success) {
        returnValue = value.data;
      }
      if(value is Error<CardActivationResponse>) {
        throw Exception(value.message);
      }
    }
    return returnValue;
  }

}