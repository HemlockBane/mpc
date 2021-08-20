import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:http_parser/http_parser.dart';

import 'data/card_activation_response.dart';
import 'data/card_linking_response.dart';
import 'data/card_request_balance_response.dart';
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

  @GET("check-sufficient-balance")
  Future<ServiceResult<CardRequestBalanceResponse>> confirmAccountBalanceIsSufficient(
      @Query("accountNumber") String accountNumber,
  );

  @Headers(<String, dynamic>{
    'Content-Type': 'multipart/form-data',
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION,
  })
  @POST("link-card")
  Future<ServiceResult<CardLinkingResponse>> linkCard(
      @Query("customerId") String customerId,
      @Part(name: "customerAccountId") String customerAccountId,
      @Part(name: "image1", contentType: "application/json") File firstCapture,
      @Part(name: "image2", contentType: "application/json") File motionCapture,
      {
        @Part(name: "customerCode") String? customerCode,
        @Part(name: "cardSerial") String? cardSerial
      }
  );

  @Headers(<String, dynamic>{
    'Content-Type': 'multipart/form-data',
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION,
  })
  @POST("activate-card")
  Future<ServiceResult<CardActivationResponse>> activateCard(
      @Query("customerId") String customerId,
      @Part(name: "customerAccountId") String customerAccountId,
      @Part(name: "image1", contentType: "application/json") File firstCapture,
      @Part(name: "image2", contentType: "application/json") File motionCapture,
      @Part(name: "customerCode") String customerCode,
      @Part(name: "cardId") int? cardId,
      @Part(name: "cvv2") String? cvv2,
      @Part(name: "newPin") String? newPin
  );

}