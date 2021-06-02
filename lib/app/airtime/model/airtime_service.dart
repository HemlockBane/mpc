import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_history_collection.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_request_body.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/history_request_body.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

part 'airtime_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.VAS_SERVICE}api/v1/airtime/")
abstract class AirtimeService {

  factory AirtimeService (Dio dio, {String baseUrl}) = _AirtimeService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("single")
  Future<ServiceResult<TransactionStatus>> buySingleAirtime(@Body() AirtimePurchaseRequestBody? airtimePurchaseRequestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("history")
  Future<ServiceResult<AirtimeHistoryCollection>> getSingleAirtimeHistory(@Body() HistoryRequestBody? airtimeHistoryRequestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("providers")
  Future<ServiceResult<List<AirtimeServiceProvider>>> getServiceProviders();

}