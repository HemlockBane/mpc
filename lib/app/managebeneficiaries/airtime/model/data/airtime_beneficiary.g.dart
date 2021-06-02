// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_beneficiary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirtimeBeneficiary _$AirtimeBeneficiaryFromJson(Map<String, dynamic> json) {
  return AirtimeBeneficiary(
    id: json['id'] as int,
    name: json['name'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    serviceProvider: json['serviceProvider'] == null
        ? null
        : AirtimeServiceProvider.fromJson(json['serviceProvider'] as Object),
    frequency: json['frequency'] as int?,
    lastUpdated: json['lastUpdated'] as int?,
  );
}

Map<String, dynamic> _$AirtimeBeneficiaryToJson(AirtimeBeneficiary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'serviceProvider': instance.serviceProvider,
      'frequency': instance.frequency,
      'lastUpdated': instance.lastUpdated,
    };
