import 'package:json_annotation/json_annotation.dart';

part 'bvn_otp_validation_request.g.dart';

@JsonSerializable()
class BVNOTPValidationRequest {
  @JsonKey(name:"bvn")
  String? bvn;
  @JsonKey(name:"phone")
  String? phoneNumber;
  @JsonKey(name:"otp")
  String? otp;
  @JsonKey(name:"dob")
  String? dob;

  BVNOTPValidationRequest();

  factory BVNOTPValidationRequest.fromJson(Map<String, dynamic> data) => _$BVNOTPValidationRequestFromJson(data);
  Map<String, dynamic> toJson() => _$BVNOTPValidationRequestToJson(this);

}