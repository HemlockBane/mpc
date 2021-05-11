import 'package:json_annotation/json_annotation.dart';

part 'authentication_request.g.dart';

@JsonSerializable()
class AuthenticationRequest {
  @JsonKey(name:"authenticationType")
  String? authenticationType;
  @JsonKey(name:"otp")
  String? otp;
  @JsonKey(name:"userCode")
  String? userCode;

  AuthenticationRequest();

  factory AuthenticationRequest.fromJson(Object? data) => _$AuthenticationRequestFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AuthenticationRequestToJson(this);

}