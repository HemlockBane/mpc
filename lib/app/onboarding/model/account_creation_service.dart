import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_validation_request.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/file_uuid.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';
import 'data/bvn_otp_result.dart';
import 'data/bvn_otp_validation_request.dart';
import 'data/bvn_otp_validation_result.dart';

part 'account_creation_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/account_creation")
abstract class AccountCreationService {
  factory AccountCreationService(Dio dio) = _AccountCreationService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/validate_bvn")
  Future<ServiceResult<BVNValidationRequest>> validateBVN(
      @Body() BVNValidationRequest validationRequest);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/get_bvn_otp")
  Future<ServiceResult<BVNOTPResult>> requestBVNOTP(
      @Body() BVNOTPValidationRequest otpRequest);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/upload")
  Future<ServiceResult<FileUUID>> uploadImageForUUID(@Part(value: "file") File selfieImage);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("/validate_bvn_otp")
  Future<ServiceResult<BVNOTPValidationResult>> validateBVNOTP(
      @Body() BVNOTPValidationRequest validationRequest);
}
