import 'package:moniepoint_flutter/core/models/gender.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bvn_validation_request.g.dart';

@JsonSerializable()
class BVNValidationRequest {
  @JsonKey(name:"bvn")
  String? bvn;
  @JsonKey(name:"firstName")
  String? firstName;
  @JsonKey(name:"middleName")
  String? middleName;
  @JsonKey(name:"lastName")
  String? lastName;
  @JsonKey(name:"dob")
  String? dob;
  @JsonKey(name:"phoneNumber")
  String? phoneNumber;
  @JsonKey(name:"mobileNo")
  String? mobileNumber;
  @JsonKey(name:"emailAddress")
  String? emailAddress;
  @JsonKey(name:"otp")
  String? otp;
  @JsonKey(name:"gender")
  Gender? gender;

  BVNValidationRequest();

  factory BVNValidationRequest.fromJson(Object? data) => _$BVNValidationRequestFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BVNValidationRequestToJson(this);

}