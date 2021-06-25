
import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/http.dart';

import '../file_result.dart';


part 'file_management_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v1/file-management/")
abstract class FileManagementService {
  factory FileManagementService(Dio dio) = _FileManagementService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("get-file")
  Future<ServiceResult<FileResult>> getFile(@Query("fileUUID") String fileUUID);
}