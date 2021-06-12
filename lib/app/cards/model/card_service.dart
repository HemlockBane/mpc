import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/card_transaction_request.dart';

part 'card_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/card/")
abstract class CardService {

  factory CardService (Dio dio, {String baseUrl}) = _CardService;


  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("get_cards/{customerAccountId}")
  Future<ServiceResult<List<Card>>> getCards(@Path("customerAccountId") int customerAccountId);

  @POST("block_card_channel")
  Future<ServiceResult<bool>> blockCardChannel(
    @Query("customerId") int customerAccountId,
    @Body() CardTransactionRequest cardChannelRequest
  );

  @POST("change_card_pin")
  Future<ServiceResult<bool>> changeCardPin(
      @Query("customerId") int customerAccountId,
      @Body() CardTransactionRequest cardChannelRequest
  );

  @POST("unblock_card_channel")
  Future<ServiceResult<bool>> unblockCardChannel(
    @Query("customerId") int customerAccountId,
    @Body() CardTransactionRequest cardChannelRequest
  );

  @POST("block_card")
  Future<ServiceResult<bool>> blockCard(
    @Query("customerId") int customerAccountId,
    @Body() CardTransactionRequest blockRequest
  );

  @POST("unblock_card")
  Future<ServiceResult<bool>> unblockCard(
    @Query("customerId") int customerAccountId,
    @Body() CardTransactionRequest unblockRequest
  );

}