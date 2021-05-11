import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/login/model/data/login_request.dart';
import 'authentication_method.dart';


part 'password_login_request.g.dart';

@JsonSerializable()
class LoginWithPasswordRequestBody extends LoginRequestBody {
  @JsonKey(name: "password")
  String? password;

  LoginWithPasswordRequestBody() : super();

  factory LoginWithPasswordRequestBody.fromJson(Map<String, dynamic> data) => _$LoginWithPasswordRequestBodyFromJson(data);

  Map<String, dynamic> toJson() => _$LoginWithPasswordRequestBodyToJson(this);

  LoginWithPasswordRequestBody withPassword(String password) {
    this.password = password;
    return this;
  }
}
