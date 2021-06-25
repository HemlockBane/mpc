import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/airtime_purchase_request_body.dart';

part 'data_top_up_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.VAS_SERVICE}api/v1/data-topup/")
abstract class DataTopUpService {

  factory DataTopUpService (Dio dio, {String baseUrl}) = _DataTopUpService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("single")
  Future<ServiceResult<TransactionStatus>> buySingleData(@Body() AirtimePurchaseRequestBody? airtimePurchaseRequestBody);


  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("providers")
  Future<ServiceResult<List<AirtimeServiceProvider>>> getServiceProviders();

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("data-provider-items/{billerId}")
  Future<ServiceResult<List<AirtimeServiceProviderItem>>> getServiceProviderItems(@Path("billerId") String billerId);

  @Headers(<String, dynamic>{
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("receipt/{customerId}/{batchId}")
  @DioResponseType(ResponseType.stream)
  Future<dynamic> downloadAirtimeDataReceipt(
      @Path("customerId") String? customerId,
      @Path("batchId") int batchId
  );
}