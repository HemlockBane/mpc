import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/validation/model/data/trigger_otp_request.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_answer_response.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_device_switch_request.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';
import 'package:http_parser/http_parser.dart';

import 'package:retrofit/retrofit.dart';

import 'data/edit_device_request.dart';

part 'validation_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/authentication")
abstract class ValidationService  {

  factory ValidationService (Dio dio) = _ValidationService;

  @POST("${ServiceConfig.OPERATION_SERVICE}api/v1/switch-device/trigger-otp")
  @Headers(<String, dynamic>{
    "Content-Type": "multipart/form-data",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<OTP>> triggerOTP(@Part(name: "username") String username);

  @POST("${ServiceConfig.OPERATION_SERVICE}api/v1/switch-device/validate-otp")
  @Headers(<String, dynamic>{
    "Content-Type": "multipart/form-data",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<ValidateAnswerResponse>> validateOtp(
      @Part() String username,
      @Part() String otp,
      @Part() String userCode,
  );

  @POST("${ServiceConfig.OPERATION_SERVICE}api/v1/switch-device/register-device")
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<bool>> editDevice(@Body() EditDeviceRequestBody editDeviceRequestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "multipart/form-data",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("${ServiceConfig.OPERATION_SERVICE}api/v1/switch-device/liveliness-check")
  Future<ServiceResult<ValidateAnswerResponse>> validateLivelinessForDevice(
      @Part(name: "image1", contentType: "application/json") File firstCapture,
      @Part(name: "image2", contentType: "application/json") File motionCapture,
      @Part(name: "validationKey") String otpValidationKey,
      @Part(name: "username") String username,
  );

}