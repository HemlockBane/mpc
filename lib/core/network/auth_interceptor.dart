import 'dart:io';

import 'package:dio/dio.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    User? user = UserInstance().getUser();
    if(user != null && (user.accessToken != null && user.accessToken?.isNotEmpty == true)) {
      options.headers["Authorization"] = "${user.tokenType} ${user.accessToken}";
      options.headers["client-id"] = (Platform.isAndroid) ? "ANDROID" : (Platform.isIOS) ? "IOS" : "UNKNOWN";
    }
    super.onRequest(options, handler);
  }
}