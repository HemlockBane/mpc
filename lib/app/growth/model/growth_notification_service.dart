
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/http.dart';

import 'data/notification_status_type.dart';

part 'growth_notification_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.GROWTH_SERVICE}api/v1/notification/")
abstract class GrowthNotificationService {

  factory GrowthNotificationService(Dio dio) = _GrowthNotificationService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @PATCH("{notificationId}")
  Future<ServiceResult<dynamic>> updateNotificationAction(
      @Path("notificationId") int notificationId,
      @Query("statusType") String statusType,
  );

}