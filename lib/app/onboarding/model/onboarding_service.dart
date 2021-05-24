import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_profile_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/validation_key.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/account_info_request.dart';
import 'data/profile_request.dart';
import 'data/validation_otp_request.dart';

part 'onboarding_service.g.dart';

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
  @POST("${ServiceConfig.ROOT_SERVICE}api/v1/account_creation")
  Future<ServiceResult<AccountProfile>> createAccount(@Body() AccountCreationRequestBody body);

  // @Headers(
  //     "Content-Type: application/json",
  //     "client-id: " + BuildConfig.CLIENT_ID,
  //     "appVersion: " + BuildConfig.APP_VERSION
  // )
  // @POST("validate_username")
  // suspend fun validateUsername(@Body body: ValidateUsernameRequestBody?): BooleanServiceResult

}