
import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/http.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';

import 'data/change_password_request_body.dart';
import 'data/change_pin_request_body.dart';
import 'data/finger_print_auth_request_body.dart';


part 'usermanagement_service.g.dart';


@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/")
abstract class UserManagementService {

  factory UserManagementService(Dio dio) = _UserManagementService;

  @Headers(<String, dynamic>{
    "Content-Type": "multipart/form-data",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("v2/user/forgot_username")
  Future<ServiceResult<RecoveryResponse>> forgotUsername(
      @Body() ForgotPasswordRequest request,
      {
        @Part(name: "image1", contentType: "application/json") File? firstCapture,
        @Part(name: "image2", contentType: "application/json") File? motionCapture,
      }
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("v2/user/forgot_password")
  Future<ServiceResult<RecoveryResponse>> forgotPassword(@Body() ForgotPasswordRequest request);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("v2/user/forgot_password/send_otp")
  Future<ServiceResult<OTP>> sendForgotPasswordOtp(@Body() ForgotPasswordRequest request);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("v2/user/forgot_username/send_otp")
  Future<ServiceResult<OTP>> sendForgotUsernameOtp(@Body() ForgotPasswordRequest request);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @PUT("v1/user/change_transaction_pin")
  Future<ServiceResult<bool>> changeTransactionPin(
    @Body() ChangePinRequestBody requestBody
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @PUT("v1/user/change_password")
  Future<ServiceResult<bool>> changePassword(
    @Body() ChangePasswordRequestBody requestBody
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @PUT("v1/user/set_fingerprint")
  Future<ServiceResult<bool>> setFingerprint(
    @Body() FingerPrintAuthRequestBody? requestBody,
  );

  // @Headers(<String, dynamic>{
  //   'Content-Type': 'multipart/form-data',
  //   "client-id": BuildConfig.CLIENT_ID,
  //   "appVersion": BuildConfig.APP_VERSION,
  // })
  // @POST("check-for-liveliness")
  // Future<ServiceResult<RecoveryLivelinessResponse>> validateLivelinessForOnboarding(
  //     @Part(name: "image1", contentType: "application/json") File firstCapture,
  //     @Part(name: "image2", contentType: "application/json") File motionCapture,
  //     @Part(name: "otpValidationKey") String otpValidationKey,
  //     {
  //       @Part(name:"step") String step = "LIVELINESS_CHECK",
  //       @Part(name: "key") String key,
  //       @Part(name: "username") String username,
  //     }
  // );

}