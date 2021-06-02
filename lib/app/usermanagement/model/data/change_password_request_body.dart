import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_body.g.dart';

@JsonSerializable()
class ChangePasswordRequestBody  {
  @JsonKey(name:"oldPassword")
  String? oldPassword;

  @JsonKey(name:"newPassword")
  String? newPassword;

  ChangePasswordRequestBody();

  factory ChangePasswordRequestBody.fromJson(Object? data) => _$ChangePasswordRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ChangePasswordRequestBodyToJson(this);

  ChangePasswordRequestBody withOldPassword(String oldPassword) {
    this.oldPassword = oldPassword;
    return this;
  }

  ChangePasswordRequestBody withNewPassword(String newPassword) {
    this.newPassword = newPassword;
    return this;
  }

}