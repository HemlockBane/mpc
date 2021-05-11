import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/login/model/data/login_request.dart';
import 'authentication_method.dart';

part 'fingerprint_login_request.g.dart';

@JsonSerializable()
class LoginWithFingerprintRequestBody extends LoginRequestBody {

  @JsonKey(name: "fingerprintKey")
  String? fingerprintKey;

  LoginWithFingerprintRequestBody() : super();

  factory LoginWithFingerprintRequestBody.fromJson(Map<String, dynamic> data) => _$LoginWithFingerprintRequestBodyFromJson(data);

  Map<String, dynamic> toJson() => _$LoginWithFingerprintRequestBodyToJson(this);

  LoginWithFingerprintRequestBody withPassword(String fingerprintKey) {
    this.fingerprintKey = fingerprintKey;
    return this;
  }
}
