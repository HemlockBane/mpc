import 'package:json_annotation/json_annotation.dart';

part 'otp_response.g.dart';

@JsonSerializable()
class Response {

  @JsonKey(name:"userCode")
  String? userCode;

  Response withUserCode(String userCode) {
    this.userCode = userCode;
    return this;
  }

  Response();

  factory Response.fromJson(Object? data) => _$ResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

}