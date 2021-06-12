// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchInfo _$BranchInfoFromJson(Map<String, dynamic> json) {
  return BranchInfo()
    ..id = json['id'] as int?
    ..name = json['name'] as String?
    ..phoneNumber = json['phoneNumber'] as String?
    ..email = json['email'] as String?
    ..location = json['location'] == null
        ? null
        : Locations.fromJson(json['location'] as Object)
    ..branchManger = json['branchManger']
    ..customerSupportOfficers = json['customerSupportOfficers'];
}

Map<String, dynamic> _$BranchInfoToJson(BranchInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'location': instance.location,
      'branchManger': instance.branchManger,
      'customerSupportOfficers': instance.customerSupportOfficers,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) {
  return Locations()
    ..streetNumber = json['streetNumber'] as String?
    ..streetName = json['streetName'] as String?
    ..lga = json['lga']
    ..city = json['city'] as String?
    ..latitude = json['latitude'] as String?
    ..longitude = json['longitude'] as String?;
}

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'streetNumber': instance.streetNumber,
      'streetName': instance.streetName,
      'lga': instance.lga,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
