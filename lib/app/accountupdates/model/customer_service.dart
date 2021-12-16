import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_update.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/cba_customer_info.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/file_uuid.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/http.dart';

part 'customer_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/customers/")
abstract class CustomerService {

  factory CustomerService(Dio dio) = _CustomerService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("onboarding-schemes")
  Future<ServiceResult<List<Tier>>> getAllOnboardingSchemes();

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("update-customer-info")
  Future<ServiceResult<AccountUpdate>> updateCustomerInfo(@Query("customerId") int customerId, @Body() AccountUpdate requestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("customer-scheme/eligible")
  Future<ServiceResult<Tier>> checkCustomerEligibility(@Query("customerId") int customerId, @Body() AccountUpdate accountUpdateRequest);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("cba-info")
  Future<ServiceResult<CBACustomerInfo>> getCustomerInfo(@Query("customerId") int customerId);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("upload")
  Future<ServiceResult<FileUUID>> uploadDocument(@Part(value: "multipartFile") File selfieImage);

}