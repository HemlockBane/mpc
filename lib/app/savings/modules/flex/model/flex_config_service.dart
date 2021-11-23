import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/http.dart';

import 'data/flex_saving_config_request_body.dart';


part 'flex_config_service.g.dart';


@RestApi(baseUrl: "${ServiceConfig.SAVINGS_SERVICE}api/v1/")
abstract class FlexConfigService {

  factory FlexConfigService(Dio dio) = _FlexConfigService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("flex/saving/create-customer-config")
  Future<ServiceResult<FlexSavingConfig>> createCustomerFlexConfig(
      @Body() FlexSavingConfigRequestBody request
  );

}