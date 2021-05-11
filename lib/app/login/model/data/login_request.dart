import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';

import 'authentication_method.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequestBody {
  @JsonKey(name:"clientId")
  final String clientId = BuildConfig.CLIENT_ID;
  @JsonKey(name:"phoneType")
  final String phoneType = "ANDROID";
  @JsonKey(name:"authenticationType")
  AuthenticationMethod? authenticationType;
  @JsonKey(name:"username")
  String username = "";
  @JsonKey(name:"deviceId")
  String? deviceId;
  @JsonKey(name:"deviceName")
  String? deviceName;
  @JsonKey(name:"version")
  String version = BuildConfig.APP_VERSION;

  LoginRequestBody();

  factory LoginRequestBody.fromJson(Object? data) => _$LoginRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$LoginRequestBodyToJson(this);


  LoginRequestBody withUsername(String username) {
    this.username = username;
    return this;
  }

  LoginRequestBody withDeviceId(String? deviceId) {
    this.deviceId = deviceId;
    return this;
  }

  LoginRequestBody withDeviceName(String? deviceName) {
    this.deviceName = deviceName;
    return this;
  }

  LoginRequestBody withVersion(String version) {
    this.version = version;
    return this;
  }
}