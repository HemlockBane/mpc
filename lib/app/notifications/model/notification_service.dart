
import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

import 'data/register_device_token_request.dart';


part 'notification_service.g.dart';


@RestApi(baseUrl: "${ServiceConfig.NOTIFICATION_SERVICE}api/v1/notification/")
abstract class NotificationService  {

  factory NotificationService(Dio dio) = _NotificationService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("register-device-token")
  Future<ServiceResult<bool>> registerDeviceToken(
    @Body() RegisterDeviceTokenRequest request
  );

}