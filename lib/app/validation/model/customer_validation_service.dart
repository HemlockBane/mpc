import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/devicemanagement/model/data/user_device_request_body.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';

import 'package:retrofit/retrofit.dart';

import 'data/validate_phone_otp_response.dart';

part 'customer_validation_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v2/customer-validation/")
abstract class CustomerValidationService {

  factory CustomerValidationService (Dio dio) = _CustomerValidationService;

  @POST("send-phone-number-validation-otp/onboarding")
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<dynamic>> sendOtpToPhoneNumber(
      @Query("phoneNumber") String phoneNumber,
      @Body() UserDeviceRequestBody securityQuestionsRequestBody,
  );

  @POST("validate-phone-number-validation-otp/onboarding")
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<ValidatePhoneOtpResponse>> validateOtpForPhoneNumber(
      @Query("otp") String otp,
      @Query("phoneNumber") String phoneNumber,
      @Body() UserDeviceRequestBody securityQuestionsRequestBody
  );

}