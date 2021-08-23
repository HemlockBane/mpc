import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/models/security_answer.dart';

part 'profile_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ProfileCreationRequestBody {

  @JsonKey(name: "accountNumber")
  String? accountNumber = "";

  @JsonKey(name: "referralCode")
  String? referralCode = "";

  @JsonKey(name: "username")
  String? username;

  @JsonKey(name: "emailAddress")
  String? emailAddress;

  @JsonKey(name: "password")
  String? password;

  @JsonKey(name: "pin")
  String? pin;

  @JsonKey(name: "onboardingKey")
  String? onboardingKey;

  @JsonKey(name: "securityAnswers")
  List<SecurityAnswer> securityAnwsers = [];

  @JsonKey(name: "deviceId")
  String? deviceId;

  @JsonKey(name: "deviceName")
  String? deviceName;

  ProfileCreationRequestBody();

  factory ProfileCreationRequestBody.fromJson(Map<String, dynamic> data) => _$ProfileCreationRequestBodyFromJson(data);
  Map<String, dynamic> toJson() => _$ProfileCreationRequestBodyToJson(this);


  ProfileCreationRequestBody withAccountNumber(String accountNumber) {
    this.accountNumber = accountNumber;
    return this;
  }

  ProfileCreationRequestBody withReferralCode(String referralCode) {
    this.referralCode = referralCode;
    return this;
  }

  ProfileCreationRequestBody withUsername(String username) {
    this.username = username;
    return this;
  }

  ProfileCreationRequestBody withPassword(String password) {
    this.password = password;
    return this;
  }

  ProfileCreationRequestBody withPin(String pin) {
    this.pin = pin;
    return this;
  }

  ProfileCreationRequestBody withOnboardingKey(String onboardingKey) {
    this.onboardingKey = onboardingKey;
    return this;
  }

  ProfileCreationRequestBody withSecurityAnswers(
      List<SecurityAnswer> securityAnswers) {
    this.securityAnwsers = securityAnswers;
    return this;
  }

  List<SecurityAnswer> getSecurityAnswers() {
    return securityAnwsers;
  }

  void setSecurityAnswers(List<SecurityAnswer> securityAnswers) {
    this.securityAnwsers = securityAnswers;
  }

  ProfileCreationRequestBody withDeviceId(String deviceId) {
    this.deviceId = deviceId;
    return this;
  }

  ProfileCreationRequestBody withDeviceName(String deviceName) {
    this.deviceName = deviceName;
    return this;
  }
}


