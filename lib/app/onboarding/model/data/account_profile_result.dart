import 'package:json_annotation/json_annotation.dart';

part 'account_profile_result.g.dart';

@JsonSerializable()
class AccountProfile {
  @JsonKey(name:"transactionReference")
  String? transactionReference;
  @JsonKey(name:"accountNumber")
  String? accountNumber;
  @JsonKey(name:"accountName")
  String? accountName;
  @JsonKey(name:"customerId")
  String? customerId;
  @JsonKey(name:"meta")
  String? meta;

  AccountProfile();

  factory AccountProfile.fromJson(Object? data) => _$AccountProfileFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccountProfileToJson(this);

}
