import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_history_collection.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/http.dart';

part 'transaction_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/transactions/")
abstract class TransactionService {

  factory TransactionService(Dio dio) = _TransactionService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("filter")
  Future<ServiceResult<TransactionHistoryCollection>> getTransactionsFilter(
      @Query("customerAccountId") int customerAccountId,
      @Query("transactionType") String transactionType,
      @Query("channel") String? channels,
      @Query("startDate") int startDate,
      @Query("endDate") int endDate,
      @Query("page") int page,
      @Query("pageSize") int pageSize);

}
