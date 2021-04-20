import 'package:json_annotation/json_annotation.dart';

import 'otp_response.dart';

part 'otp.g.dart';

@JsonSerializable()
class OTP {

  @JsonKey(name:"response")
  Response? response;

  @JsonKey(name:"phoneNumber")
  String? phoneNumber;

  @JsonKey(name:"email")
  String? email;

  @JsonKey(name:"userCode")
  String? userCode;

  @JsonKey(name:"narration")
  String? narration;

  @JsonKey(name:"notificationServiceResponseCode")
  String? notificationServiceResponseCode;

  OTP();

  factory OTP.fromJson(Object? data) => _$OTPFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$OTPToJson(this);


  void setResponse(Response response) {
    this.response = response;
  }

  OTP withResponse(Response response) {
    this.response = response;
    return this;
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  OTP withPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    return this;
  }


  OTP withEmail(String email) {
    this.email = email;
    return this;
  }

  OTP withUserCode(String userCode) {
    this.userCode = userCode;
    return this;
  }

  OTP withNarration(String narration) {
    this.narration = narration;
    return this;
  }

  OTP withNotificationServiceResponseCode(String notificationServiceResponseCode) {
    this.notificationServiceResponseCode = notificationServiceResponseCode;
    return this;
  }
}
