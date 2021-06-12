import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/branch_info.dart';
import 'data/branch_info_collection.dart';

part 'branch_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v1/monnify-branch/")
abstract class BranchService {

  factory BranchService (Dio dio, {String baseUrl}) = _BranchService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("within-radius")
  Future<ServiceResult<List<BranchInfo>>> getAllBranches(
      @Query("longitude") double longitude,
      @Query("latitude") double latitude,
      @Query("radiusInMiles") int radiusInMiles
  );

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("search?")
  Future<ServiceResult<BranchInfoCollection>> searchBranchByName(@Query("name") String name);

}