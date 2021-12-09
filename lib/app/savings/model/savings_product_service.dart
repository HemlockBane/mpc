import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/model/data/total_savings_balance.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_account_balance.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_free_withdrawal_count_request.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_top_up_request.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_top_up_response.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_transaction_history_collection.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_withdrawal_count.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/http.dart';

import 'data/enable_flex_request_body.dart';

part 'savings_product_service.g.dart';


@RestApi(baseUrl: "${ServiceConfig.SAVINGS_SERVICE}api/v1/")
abstract class SavingsProductService {

  factory SavingsProductService(Dio dio) = _SavingsProductService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("flex/saving/get-product")
  Future<ServiceResult<SavingsProduct>> getFlexProduct();

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("flex/saving/get-running")
  Future<ServiceResult<List<FlexSaving>>> getRunningFlexSavings(
     @Query("customerId") int customerId
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("flex/saving/enable-flex-account")
  Future<ServiceResult<FlexSaving>> enableFlexSavings(
      @Body() EnableFlexRequestBody request
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("flex/saving/top-up")
  Future<ServiceResult<FlexTopUpResponse>> doFlexTopUp(
      @Body() FlexTopUpRequest request
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("flex/saving/withdraw")
  Future<ServiceResult<FlexTopUpResponse>> withdraw(
      @Body() FlexTopUpRequest request
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("flex/saving/free-withdrawal-count")
  Future<ServiceResult<FlexWithdrawalCount>> getFreeWithdrawalCount(
      @Body() FlexFreeWithdrawalCountRequest request
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("flex/saving/transactions/filter")
  Future<ServiceResult<FlexTransactionHistoryCollection>> getTransactionsFilter(
      @Query("customerFlexSavingId") int customerFlexSavingId,
      @Query("transactionType") String? transactionType,
      @Query("startDate") int? startDate,
      @Query("endDate") int? endDate,
      @Query("page") int page,
      @Query("pageSize") int pageSize
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("flex/saving/get-balance")
  Future<ServiceResult<FlexAccountBalance>> getFlexAccountBalance(
      @Query("customerFlexSavingId") int customerFlexSavingId,
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("${ServiceConfig.SAVINGS_SERVICE}api/v1/saving/get-all-balance")
  Future<ServiceResult<TotalSavingsBalance>> getAllSavingsBalance(
      @Query("customerId") int customerId,
  );



}
