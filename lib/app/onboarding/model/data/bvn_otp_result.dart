import 'package:json_annotation/json_annotation.dart';

part 'bvn_otp_result.g.dart';

@JsonSerializable()
class BVNOTPResult {
  @JsonKey(name:"notificationServiceResponseCode")
  String? notificationServiceResponseCode;

  BVNOTPResult();

  factory BVNOTPResult.fromJson(Object? data) => _$BVNOTPResultFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BVNOTPResultToJson(this);

}