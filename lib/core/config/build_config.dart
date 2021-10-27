
import 'package:moniepoint_flutter/core/config/service_config.dart';

class BuildConfig {
  static const String CLIENT_ID = "ANDROID";
  static const String APP_VERSION = (ServiceConfig.ENV == "dev") ? "0.0.1" : "1.1.0";
}