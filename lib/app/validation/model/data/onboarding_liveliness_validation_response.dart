import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_error.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';

part 'onboarding_liveliness_validation_response.g.dart';

@JsonSerializable()
class OnboardingLivelinessValidationResponse {
  OnboardingLivelinessValidationResponse({
    this.livelinessError,
    this.faceMatchError,
    this.bvnMismatchError,
    this.phoneMismatchError,
    this.setupType,
    this.onboardingKey,
    this.mobileProfileExist,
  });

  LivelinessError? livelinessError;
  ClientError? faceMatchError;
  ClientError? bvnMismatchError;
  ClientError? phoneMismatchError;
  SetupType? setupType;
  String? onboardingKey;
  bool? mobileProfileExist;

  factory OnboardingLivelinessValidationResponse.fromJson(Object? data) => _$OnboardingLivelinessValidationResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$OnboardingLivelinessValidationResponseToJson(this);

}

enum OnBoardingType {
  ACCOUNT_EXIST, ACCOUNT_DOES_NOT_EXIST
}

@JsonSerializable()
class SetupType {
  SetupType({
    this.type,
  });

  OnBoardingType? type;

  factory SetupType.fromJson(Object? data) => _$SetupTypeFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SetupTypeToJson(this);

}
