import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/system_configuration.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/http.dart';

part 'system_configuration_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v1/system-configuration/")
abstract class SystemConfigurationService {
  factory SystemConfigurationService(Dio dio) = _SystemConfigurationService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("")
  Future<ServiceResult<List<SystemConfiguration>>> getAllSystemConfigs();
}