import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';

part 'institution_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/institution/")
abstract class InstitutionService {

  factory InstitutionService (Dio dio, {String baseUrl}) = _InstitutionService;

  @GET("account_provider")
  Future<ServiceResult<List<AccountProvider>>> getAccountProviders();
  
}
