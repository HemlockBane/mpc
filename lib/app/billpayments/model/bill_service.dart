import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_history_collection.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_request_body.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_history_collection.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_payment_request_body.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_validation_status.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/history_request_body.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

part 'bill_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.VAS_SERVICE}api/v1/bill/")
abstract class BillService {

  factory BillService (Dio dio, {String baseUrl}) = _BillService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("products_by_billers")
  Future<ServiceResult<List<BillerProduct>>> getProductsByBiller(@Query("billerCode") String billerCode);


  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("billers_by_category")
  Future<ServiceResult<List<Biller>>> getBillersByCategory(@Query("categoryCode") String categoryCode);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("categories")
  Future<ServiceResult<List<BillerCategory>>> getBillerCategories();

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("")
  Future<ServiceResult<TransactionStatus>> paySingleBill(@Body() BillPaymentRequestBody? requestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("history")
  Future<ServiceResult<BillHistoryCollection>> getBillHistory(@Body() HistoryRequestBody? billHistoryRequestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("validate")
  Future<ServiceResult<BillValidationStatus>> validateCustomerBillPayment(
      @Query("customerId") String customerId,
      @Query("productCode") String paymentCode
      );
}