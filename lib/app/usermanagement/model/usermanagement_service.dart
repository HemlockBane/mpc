
import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/usermanagement/model/data/forgot_password_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/http.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';


part 'usermanagement_service.g.dart';


@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v1/user")
abstract class UserManagementService {

    factory UserManagementService(Dio dio) = _UserManagementService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/forgot_username")
  Future<ServiceResult<RecoveryResponse>> forgotUsername(@Body() ForgotPasswordRequest request);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/forgot_password")
  Future<ServiceResult<RecoveryResponse>> forgotPassword(@Body() ForgotPasswordRequest request);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/forgot_password/send_otp")
  Future<ServiceResult<OTP>> sendForgotPasswordOtp(@Body() ForgotPasswordRequest request);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/forgot_username/send_otp")
  Future<ServiceResult<OTP>> sendForgotUsernameOtp(@Body() ForgotPasswordRequest request);


// @Headers("Content-Type: application/json")
// @GET("check_username")
// suspend fun
// checkIfUsernameAvailable
// (
// @Query("username")
// username: String?):
// BooleanServiceResult
//
// @Headers("Content-Type: application/json")
// @PUT("set_password_with_key")
// suspend fun
// setPasswordWithKey
// (
// @Body
// requestBody: SetPasswordWithKeyRequestBody?):
// CredentialsUpdateServiceResult
//
// @Headers("Content-Type: application/json")
// @PUT("change_transaction_pin")
// suspend fun
// changeTransactionPin
// (
// @Header(HeaderKeys.AUTHORIZATION)
// user: User?,@Body
// requestBody: ChangePinRequestBody?,)
// :
// CredentialsUpdateServiceResult
//
// @Headers("Content-Type: application/json")
// @PUT("change_password")
// suspend fun
// changePassword
// (
// @Header(HeaderKeys.AUTHORIZATION)
// user: User?,@Body
// requestBody: ChangePasswordRequestBody?,)
// :
// CredentialsUpdateServiceResult
//
// @Headers("Content-Type: application/json")
// @PUT("set_transaction_pin_with_key")
// suspend fun
// setTransactionPin
// (
// @Header(HeaderKeys.AUTHORIZATION)
// user: User?,@Body
// requestBody: SetPinRequestBody?,)
// :
// CredentialsUpdateServiceResult
//
// @Headers("Content-Type: application/json")
// @PUT("set_fingerprint")
// suspend fun
// setFingerprint
// (
// @Header(HeaderKeys.AUTHORIZATION)
// user: User?,@Body
// requestBody: FingerPrintAuthRequestBody?,)
// :
// CredentialsUpdateServiceResult?

}