import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/bill_beneficiary.dart';
import 'data/bill_beneficiary_collection.dart';

part 'bill_beneficiary_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v1/biller_beneficiary/")
abstract class BillBeneficiaryService {

  factory BillBeneficiaryService (Dio dio, {String baseUrl}) = _BillBeneficiaryService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("paged/{customerId}")
  Future<ServiceResult<BillBeneficiaryCollection>> getBillerBeneficiaries(
      @Path("customerId") int customerId,
      @Query("page") int? page,
      @Query("pageSize") int? pageSize
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("frequent/{limit}")
  Future<ServiceResult<List<BillBeneficiary>>> getFrequentBeneficiaries(@Path("limit") int limit);

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