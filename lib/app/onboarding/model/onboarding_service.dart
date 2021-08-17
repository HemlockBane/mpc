import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:http_parser/http_parser.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_profile_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/validation_key.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/account_info_request.dart';
import 'data/profile_request.dart';
import 'data/validation_otp_request.dart';

part 'onboarding_service.g.dart';

/// @author Paul Okeke

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/onboarding")
abstract class OnBoardingService {

  factory OnBoardingService (Dio dio, {String baseUrl}) = _OnBoardingService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/name_enquiry")
  Future<ServiceResult<TransferBeneficiary>> getAccount(@Body() AccountInfoRequestBody requestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/get_otp")
  Future<ServiceResult<OTP>> getOTP(@Body() AccountInfoRequestBody? requestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/validate_otp")
  Future<ServiceResult<ValidationKey>> validateOTP(@Body() ValidateOtpRequestBody? body);

  //
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/")
  Future<ServiceResult<bool>> onBoardUser(@Body() ProfileCreationRequestBody body);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("${ServiceConfig.ROOT_SERVICE}api/v2/onboarding/onboard-user")
  Future<ServiceResult<AccountProfile>> createAccount(@Body() AccountCreationRequestBody body);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("${ServiceConfig.OPERATION_SERVICE}api/v1/user/check_username")
  Future<ServiceResult<bool>> checkUsername(@Query("username") String username);

  @Headers(<String, dynamic>{
    'Content-Type': 'multipart/form-data',
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION,
  })
  @POST("${ServiceConfig.OPERATION_SERVICE}api/v2/onboarding-validation/check-for-liveliness")
  Future<ServiceResult<OnboardingLivelinessValidationResponse>> validateLivelinessForOnboarding(
      @Part(name: "image1", contentType: "application/json") File firstCapture,
      @Part(name: "image2", contentType: "application/json") File motionCapture,
      @Part(name: "bvn") String bvn,
      @Part(name: "phoneNumberValidationKey") String phoneNumberValidationKey,
  );

}