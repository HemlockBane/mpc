import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary_collection.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

part 'airtime_beneficiary_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v1/airtime_beneficiary/")
abstract class AirtimeBeneficiaryService {

  factory AirtimeBeneficiaryService (Dio dio, {String baseUrl}) = _AirtimeBeneficiaryService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("paged")
  Future<ServiceResult<AirtimeBeneficiaryCollection>> getAirtimeBeneficiaries({
    @Query("page") int? page = 0,
    @Query("pageSize") int? pageSize = 20}
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("")
  Future<ServiceResult<List<AirtimeBeneficiary>>> getFrequentBeneficiaries();

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