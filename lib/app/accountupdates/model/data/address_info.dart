import 'package:json_annotation/json_annotation.dart';

part 'address_info.g.dart';

@JsonSerializable()
class AddressInfo {
  String? addressLine;
  String? addressCity;
  int? stateId;
  int? addressLocalGovernmentAreaId;
  @JsonKey(name: "utilityBillUUID", includeIfNull: false)
  String? utilityBillUUID;

  AddressInfo({this.addressLine,
    this.addressCity,
    this.addressLocalGovernmentAreaId,
    this.utilityBillUUID});

  factory AddressInfo.fromJson(Object? data) => _$AddressInfoFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AddressInfoToJson(this);

}