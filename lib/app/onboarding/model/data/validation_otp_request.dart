import 'package:json_annotation/json_annotation.dart';

part 'validation_otp_request.g.dart';

@JsonSerializable()
class ValidateOtpRequestBody {
  @JsonKey(name:"accountNumber")
  String? accountNumber;

  @JsonKey(name:"userCode")
  String? userCode;

  @JsonKey(name:"otp")
  String? otp;


  ValidateOtpRequestBody();

  factory ValidateOtpRequestBody.fromJson(Object? data) => _$ValidateOtpRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ValidateOtpRequestBodyToJson(this);

}