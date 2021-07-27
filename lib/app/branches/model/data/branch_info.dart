import 'package:json_annotation/json_annotation.dart';

part 'branch_info.g.dart';

@JsonSerializable()
class BranchInfo {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "phoneNumber")
  String? phoneNumber;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "location")
  Locations? location;

  @JsonKey(name: "branchManger")
  Object? branchManger;

  @JsonKey(name: "customerSupportOfficers")
  Object? customerSupportOfficers;

  BranchInfo();

  factory BranchInfo.fromJson(Object? data) => _$BranchInfoFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BranchInfoToJson(this);

}

@JsonSerializable()
class Locations {
  @JsonKey(name: "streetNumber")
  String? streetNumber;

  @JsonKey(name: "streetName")
  String? streetName;

  @JsonKey(name: "lga")
  Object? lga;

  @JsonKey(name: "city")
  String? city;

  @JsonKey(name: "latitude")
  String? latitude;

  @JsonKey(name: "longitude")
  String? longitude;

  Locations();

  String get address => "$streetNumber, $streetName, $city";


  factory Locations.fromJson(Object? data) => _$LocationsFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

}
