
import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/devicemanagement/model/data/user_device.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/http.dart';

import 'data/user_device_request_body.dart';

part 'user_device_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v1/device-management/")
abstract class UserDeviceService {
  factory UserDeviceService(Dio dio) = _UserDeviceService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("get-user-devices")
  Future<ServiceResult<List<UserDevice>>> getUserDevices(@Body() UserDeviceRequestBody requestBody);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @POST("remove-user-device")
  Future<ServiceResult<bool>> deleteUserDevice(@Body() UserDeviceRequestBody requestBody);

}