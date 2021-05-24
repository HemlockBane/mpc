import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/address_info.dart';

part 'customer_detail_info.g.dart';

@JsonSerializable()
class CustomerDetailInfo {
  String? title;
  String? maritalStatus;
  @JsonKey(name: "mothersMaidenName", includeIfNull: false)
  String? mothersMaidenName;
  String? nationality;
  String? religion;
  int? localGovernmentAreaOfOriginId;
  @JsonKey(name: "gender", includeIfNull: false)
  String? gender;
  @JsonKey(name: "accountOpeningFormRef", includeIfNull: false)
  String? accountOpeningFormRef;
  String? employmentStatus;
  @JsonKey(name: "natureOfBusiness", includeIfNull: false)
  String? natureOfBusiness;
  @JsonKey(name: "addressInfo", includeIfNull: false)
  AddressInfo? addressInfo;

  CustomerDetailInfo({this.title,
    this.maritalStatus,
    this.mothersMaidenName,
    this.nationality,
    this.religion,
    this.localGovernmentAreaOfOriginId,
    this.gender,
    this.accountOpeningFormRef,
    this.employmentStatus,
    this.natureOfBusiness,
    this.addressInfo
  });

  void setAddressInfo() {

  }

  factory CustomerDetailInfo.fromJson(Object? data) => _$CustomerDetailInfoFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CustomerDetailInfoToJson(this);

}