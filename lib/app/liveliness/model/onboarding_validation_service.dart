import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:http_parser/http_parser.dart';



import 'package:retrofit/retrofit.dart';

part 'onboarding_validation_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v2/onboarding-validation/")
abstract class OnboardingValidationService {

  factory OnboardingValidationService (Dio dio) = _OnboardingValidationService;

  @Headers(<String, dynamic>{
    'Content-Type': 'multipart/form-data',
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION,
  })
  @POST("check-for-liveliness")
  Future<ServiceResult<OnboardingLivelinessValidationResponse>> validateLivelinessForOnboarding(
      @Part(name: "image1", contentType: "application/json") File firstCapture,
      @Part(name: "image2", contentType: "application/json") File motionCapture,
      @Part(name: "bvn") String bvn,
      @Part(name: "phoneNumberValidationKey") String phoneNumberValidationKey,
  );

}