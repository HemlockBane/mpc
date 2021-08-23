

import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/cards/model/card_service_delegate.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_activation_response.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_link_request.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_linking_response.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_verification_for.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_answer_response.dart';
import 'package:moniepoint_flutter/app/validation/model/validation_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class LivelinessVerificationViewModel extends BaseViewModel{

  late final OnBoardingServiceDelegate _onBoardingServiceDelegate;
  late final UserManagementServiceDelegate _userServiceDelegate;
  late final ValidationServiceDelegate _validationServiceDelegate;
  late final CardServiceDelegate _cardServiceDelegate;

  LivelinessVerificationViewModel({
    OnBoardingServiceDelegate? verificationServiceDelegate,
    UserManagementServiceDelegate? userManagementServiceDelegate,
    ValidationServiceDelegate? validationServiceDelegate,
    CardServiceDelegate? cardServiceDelegate,
  }) {
    this._onBoardingServiceDelegate = verificationServiceDelegate ?? GetIt.I<OnBoardingServiceDelegate>();
    this._userServiceDelegate = userManagementServiceDelegate ?? GetIt.I<UserManagementServiceDelegate>();
    this._validationServiceDelegate = validationServiceDelegate ?? GetIt.I<ValidationServiceDelegate>();
    this._cardServiceDelegate = cardServiceDelegate ?? GetIt.I<CardServiceDelegate>();
  }

  Stream<Resource<OnboardingLivelinessValidationResponse>> validateLivelinessForOnboarding(
      File firstCapture, File motionCapture, String bvn, String phoneNumberValidationKey) {
    return _onBoardingServiceDelegate.validateLivelinessForOnboarding(firstCapture, motionCapture, bvn, phoneNumberValidationKey);
  }

  Stream<Resource<RecoveryResponse>> validateForRecovery(
      File firstCapture, File motionCapture, ForgotPasswordRequest request) {
    return request.livelinessVerificationFor == LivelinessVerificationFor.USERNAME_RECOVERY
        ? _userServiceDelegate.forgotUsername(request, firstCapture: firstCapture, motionCapture: motionCapture)
        : _userServiceDelegate.forgotPassword(request, firstCapture: firstCapture, motionCapture: motionCapture);
  }

  Stream<Resource<ValidateAnswerResponse>> validateLivelinessForRegisterDevice(
      File firstCapture, File motionCapture, String otpValidationKey,  String username,) {
    return _validationServiceDelegate.validateLivelinessForDevice(firstCapture, motionCapture, otpValidationKey, username);
  }

  Stream<Resource<CardLinkingResponse>> validateForCardLinking(File firstCapture, File motionCapture, String? serial) {
    final cardLinkRequest = CardLinkRequest(
        firstCapture: firstCapture,
        motionCapture: motionCapture,
        customerId: "$customerId",
        customerAccountId: "$customerAccountId",
        customerCode: primaryCbaCustomerId,
        cardSerial: serial
    );
    return _cardServiceDelegate.linkCard(cardLinkRequest);
  }

  Stream<Resource<CardActivationResponse>> validateCardForActivation(File firstCapture, File motionCapture,
      int cardId, String cvv2, String newPin) {
    final cardLinkRequest = CardLinkRequest(
        firstCapture: firstCapture,
        motionCapture: motionCapture,
        customerId: "$customerId",
        customerAccountId: "$customerAccountId",
        customerCode: primaryCbaCustomerId,
        cvv: cvv2,
        newPin: newPin,
        cardId: cardId
    );
    return _cardServiceDelegate.activateCard(cardLinkRequest);
  }
}