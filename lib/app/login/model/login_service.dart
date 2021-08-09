
import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/http.dart';

import 'data/fingerprint_login_request.dart';
import 'data/password_login_request.dart';

part 'login_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/login")
abstract class LoginService {
  factory LoginService(Dio dio) = _LoginService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("${ServiceConfig.ROOT_SERVICE}api/v2/login")
  Future<ServiceResult<User>> loginWithPassword(@Body() LoginWithPasswordRequestBody requestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/")
  Future<ServiceResult<User>> loginWithFingerprint(@Body() LoginWithFingerprintRequestBody requestBody);

// @Headers(
  //     "Content-Type: application/json",
  //     "client-id: " + BuildConfig.CLIENT_ID,
  //     "appVersion: " + BuildConfig.APP_VERSION
  // )
  // @POST("./")
  // suspend fun loginWithPIN(@Body requestBody: LoginWithPINRequestBody?): UserServiceResult
  //
}