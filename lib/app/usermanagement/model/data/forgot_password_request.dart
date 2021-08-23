import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_verification_for.dart';


part 'forgot_password_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ForgotPasswordRequest {
  @JsonKey(name:"step")
  ForgotPasswordStep? step;
  @JsonKey(name:"username")
  String? username;
  @JsonKey(name:"accountNumber")
  String? accountNumber;
  @JsonKey(name:"email")
  String? email;
  @JsonKey(name:"phoneNumber")
  String? phoneNumber;
  @JsonKey(name:"bvn")
  String? bvn;
  @JsonKey(name:"userCode")
  String? otpUserCode;
  @JsonKey(name:"otpValidationKey")
  String? otpValidationKey;
  @JsonKey(name:"otp")
  String? otp;
  @JsonKey(name:"key")
  String? key;
  @JsonKey(name:"password")
  String? password;
  @JsonKey(name:"livelinessCheckRef")
  String? livelinessCheckRef;

  LivelinessVerificationFor? livelinessVerificationFor;

  ForgotPasswordRequest();

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);

  ForgotPasswordRequest withOTP(String otp){
    this.otp = otp;
    return this;
  }

  ForgotPasswordRequest withUsername(String username) {
    this.username = username;
    return this;
  }

  ForgotPasswordRequest withAccountNumber(String accountNumber) {
    this.accountNumber = accountNumber;
    return this;
  }

  ForgotPasswordRequest withEmail(String email) {
    this.email = email;
    return this;
  }

  ForgotPasswordRequest withPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    return this;
  }

  ForgotPasswordRequest withStep(ForgotPasswordStep step){
    this.step = step;
    return this;
  }

  ForgotPasswordRequest withBVN(String bvn){
    this.bvn = bvn;
    return this;
  }
}

enum ForgotPasswordStep {
  INITIATE,
  VALIDATE_SECURITY_ANSWER,
  VALIDATE_OTP,
  LIVELINESS_CHECK,
  COMPLETE
}