import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:moniepoint_flutter/core/models/history_request_body.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/transfer_history_collection.dart';
import 'data/transfer_request_body.dart';

part 'transfer_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.TRANSFER_SERVICE}api/v1/transfer/")
abstract class TransferService {

  factory TransferService (Dio dio, {String baseUrl}) = _TransferService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("")
  Future<ServiceResult<FeeVat>> getFeeVat(
      @Query("sinkAccountProviderCode")  String sinkAccountProviderCode,
      @Query("minorAmount") num minorAmount
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("all-fee-vat-configs")
  Future<ServiceResult<FeeVatConfig>> getAllFeeAndVatConfig();

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("./")
  Future<ServiceResult<TransactionStatus>> doInstantTransfer(
      @Body() TransferRequestBody? transferRequestBody
  );
//
//   @Headers("Content-Type: application/json", "client-id: " + BuildConfig.CLIENT_ID)
//   @POST("./")
//   suspend fun doScheduledTransfer(
//   @Header("Authorization") user: User?,
//   @Body transferRequestBody: ScheduledTransferRequestBody?
//   ): TransactionServiceResult
//
//   @Headers("Content-Type: application/json", "client-id: " + BuildConfig.CLIENT_ID)
//   @POST("./")
//   suspend fun doRecurringTransfer(
//   @Header("Authorization") user: User?,
//   @Body transferRequestBody: RecurringTransferRequestBody?
//   ): TransactionServiceResult
//

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @PUT("{customerId}")
  Future<ServiceResult<TransferHistoryCollection>> getSingleTransferHistory(
    @Path("customerId") String customerId,
    @Body() HistoryRequestBody? requestBody
  );
//
//   @Headers(
//       "Cache-Control: no-cache",
//       "Content-Type: application/json",
//       "client-id: " + BuildConfig.CLIENT_ID
//   )
//   @GET("upcoming/{customerId}")
//   fun getSingleUpcomingTransfers(
//   @Header("Authorization") user: User?,
//   @Path("customerId") customerId: String?
//   ): Flow<ApiResponse<SingleUpcomingTransferServiceResult>>
//
// //    @Headers("Content-Type: application/json", "client-id: " + BuildConfig.CLIENT_ID)
// //    @GET("cancel")
// //    fun cancelPayment(
// //            @Header(HeaderKeys.AUTHORIZATION) user: User?,
// //            @Query("batchKey") batchKey: String?,
// //            @Query("paymentType") paymentType: PaymentType?): Flow<ApiResponse<TransactionCancellationServiceResult>>
//
//   @Streaming
//   @Headers("Content-Type: application/json", "client-id: " + BuildConfig.CLIENT_ID)
//   @GET("receipt/{customerId}/{batchId}")
//   suspend fun downloadTransferReceipt(
//   @Header(HeaderKeys.AUTHORIZATION) user: User?,
//   @Path("customerId") customerId: String?,
//   @Path("batchId") batchId: Long
//   ): ResponseBody?
}