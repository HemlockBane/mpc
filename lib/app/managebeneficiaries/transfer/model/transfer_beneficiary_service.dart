


import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/transfer_beneficiary_collection.dart';

part 'transfer_beneficiary_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v1/beneficiary/")
abstract class TransferBeneficiaryService {

  factory TransferBeneficiaryService (Dio dio, {String baseUrl}) = _TransferBeneficiaryService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("paged")
  Future<ServiceResult<TransferBeneficiaryCollection>> getAccountBeneficiaries({
    @Query("page") int? page = 0,
    @Query("pageSize") int? pageSize = 20}
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("")
  Future<ServiceResult<List<TransferBeneficiary>>> getFrequentBeneficiaries();

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("delete")
  Future<ServiceResult<bool>> deleteBeneficiary(
    @Query("id") int id,
    @Query("customerId") int customerId,
    @Query("pin") int pin,
  );
}