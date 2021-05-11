import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/address_info.dart';

part 'customer_detail_info.g.dart';

@JsonSerializable()
class CustomerDetailInfo {
  String? title;
  String? maritalStatus;
  String? mothersMaidenName;
  String? nationality;
  String? religion;
  int? localGovernmentAreaOfOriginId;
  String? gender;
  String? accountOpeningFormRef;
  String? employmentStatus;
  String? natureOfBusiness;
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

  factory CustomerDetailInfo.fromJson(Object? data) => _$CustomerDetailInfoFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CustomerDetailInfoToJson(this);

}