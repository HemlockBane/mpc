import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/account_info_request.dart';

part 'onboarding_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/onboarding")
abstract class OnBoardingService {

  factory OnBoardingService (Dio dio) = _OnBoardingService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/name_enquiry")
  Future<ServiceResult<TransferBeneficiary>> getAccount(@Body() AccountInfoRequestBody requestBody);

  // @Headers(
  //     "Content-Type: application/json",
  //     "client-id: " + BuildConfig.CLIENT_ID,
  //     "appVersion: " + BuildConfig.APP_VERSION
  // )
  // @POST("get_otp")
  // suspend fun getOTP(@Body body: AccountInfoRequestBody?): OTPServiceResult
  //
  // @Headers(
  //     "Content-Type: application/json",
  //     "client-id: " + BuildConfig.CLIENT_ID,
  //     "appVersion: " + BuildConfig.APP_VERSION
  // )
  // @POST("validate_otp")
  // suspend fun validateOTP(@Body body: ValidateOtpRequestBody?): ValidationServiceResult
  //
  //
  // @Headers(
  //     "Content-Type: application/json",
  //     "client-id: " + BuildConfig.CLIENT_ID,
  //     "appVersion: " + BuildConfig.APP_VERSION
  // )
  // @POST("./")
  // suspend  fun onBoardUser(@Body body: ProfileCreationRequestBody?): BooleanServiceResult
  //
  // @Headers(
  //     "Content-Type: application/json",
  //     "client-id: " + BuildConfig.CLIENT_ID,
  //     "appVersion: " + BuildConfig.APP_VERSION
  // )
  // @POST("/api/v1/account_creation")
  // suspend  fun createAccount(@Body body: ProfileCreationRequestBody.AccountCreationRequestBody?): AccountCreationServiceResult
  //
  // @Headers(
  //     "Content-Type: application/json",
  //     "client-id: " + BuildConfig.CLIENT_ID,
  //     "appVersion: " + BuildConfig.APP_VERSION
  // )
  // @POST("validate_username")
  // suspend fun validateUsername(@Body body: ValidateUsernameRequestBody?): BooleanServiceResult
  //
  //
  // @Headers(
  //     "client-id: " + BuildConfig.CLIENT_ID,
  //     "appVersion: " + BuildConfig.APP_VERSION
  // )
  // @Multipart
  // @POST("validate_image")
  // suspend fun validateBioIDImage(@Part selfieImage: MultipartBody.Part? = null): BioIDValidationServiceResult

}