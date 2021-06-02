import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/address_info.dart';

part 'next_of_kin_info.g.dart';

@JsonSerializable()
class NextOfKinInfo {
  String? nextOfKinFirstName;
  String? nextOfKinLastName;
  String? nextOfKinMiddleName;
  String? nextOfKinRelationship;
  String? nextOfKinPhoneNumber;
  String? nextOfKinEmail;
  @JsonKey(name: "nextOfKinCity", includeIfNull: false)
  String? nextOfKinCity;
  String? nextOfKinDOB;
  AddressInfo? addressInfo;

  NextOfKinInfo({
    this.nextOfKinFirstName,
    this.nextOfKinLastName,
    this.nextOfKinMiddleName,
    this.nextOfKinRelationship,
    this.nextOfKinPhoneNumber,
    this.nextOfKinEmail,
    this.nextOfKinCity,
    this.nextOfKinDOB,
    this.addressInfo
  });

  factory NextOfKinInfo.fromJson(Object? data) => _$NextOfKinInfoFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$NextOfKinInfoToJson(this);

}