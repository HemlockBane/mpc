import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/trigger_otp_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_answer_response.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_device_switch_request.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';

import 'package:retrofit/retrofit.dart';

import 'data/edit_device_request.dart';

part 'validation_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/authentication")
abstract class ValidationService  {

  factory ValidationService (Dio dio) = _ValidationService;

  @POST("/validate_username_security_answer")
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<ValidateAnswerResponse>> validateUsernameSecurityAnswer(
      @Body() SecurityQuestionRequestBody securityQuestionsRequestBody
      );

  @POST("/switch_device/trigger_otp")
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<OTP>> triggerOTP(@Body() TriggerOtpRequestBody otpRequestBody);

  @POST("/switch_device/validate_otp")
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<ValidateAnswerResponse>> validateOtp(@Body() ValidateDeviceSwitchRequestBody deviceSwitchRequestBody);

  @POST("/edit_device")
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<bool>> editDevice(@Body() EditDeviceRequestBody editDeviceRequestBody);

}