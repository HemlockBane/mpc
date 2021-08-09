import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/core/device_manager.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';

class AuthInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final deviceManager = GetIt.I<DeviceManager>();

    User? user = UserInstance().getUser();
    if(user != null && (user.accessToken != null && user.accessToken?.isNotEmpty == true)) {
      options.headers["Authorization"] = "${user.tokenType} ${user.accessToken}";
    }
    options.headers["client-id"] = (Platform.isAndroid) ? "ANDROID" : (Platform.isIOS) ? "IOS" : "UNKNOWN";
    options.headers["deviceOS"] = (Platform.isAndroid) ? "ANDROID" : (Platform.isIOS) ? "IOS" : "UNKNOWN";
    options.headers["deviceId"] = "8899KKLLMMpnopkr";//deviceManager.deviceId;
    options.headers["deviceVersion"] = deviceManager.deviceVersion;
    options.headers["deviceName"] = deviceManager.deviceBrandName;
    super.onRequest(options, handler);
  }
}