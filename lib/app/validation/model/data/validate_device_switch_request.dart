import 'package:json_annotation/json_annotation.dart';

import 'authentication_request.dart';

part 'validate_device_switch_request.g.dart';

@JsonSerializable()
class ValidateDeviceSwitchRequestBody {
  @JsonKey(name:"username")
  String? username;
  @JsonKey(name:"customerType")
  String? customerType;
  @JsonKey(name:"validationKey")
  String? validationKey;
  @JsonKey(name:"otp")
  String? otp;
  @JsonKey(name:"userCode")
  String? userCode;
  // @JsonKey(name:"authenticationRequest")
  // AuthenticationRequest? authenticationRequest;

  ValidateDeviceSwitchRequestBody();

  factory ValidateDeviceSwitchRequestBody.fromJson(Object? data) => _$ValidateDeviceSwitchRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ValidateDeviceSwitchRequestBodyToJson(this);


  ValidateDeviceSwitchRequestBody withUsername(String username) {
    this.username = username;
    return this;
  }

  ValidateDeviceSwitchRequestBody withValidationKey(String validationKey) {
    this.validationKey = validationKey;
    return this;
  }

  ValidateDeviceSwitchRequestBody withUserCode(String userCode) {
    this.userCode = userCode;
    return this;
  }


  ValidateDeviceSwitchRequestBody withOtp(String otp) {
    this.otp = otp;
    return this;
  }

  // ValidateDeviceSwitchRequestBody withRequest(AuthenticationRequest request) {
  //   this.authenticationRequest = request;
  //   return this;
  // }

}