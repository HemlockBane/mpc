// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirtimeDataRequest _$AirtimeDataRequestFromJson(Map<String, dynamic> json) {
  return AirtimeDataRequest()
    ..phoneNumber = json['phoneNumber'] as String?
    ..serviceProviderCode = json['serviceProviderCode'] as String?
    ..minorCreditAmount = (json['minorCreditAmount'] as num?)?.toDouble()
    ..name = json['name'] as String?
    ..location = json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Object);
}

Map<String, dynamic> _$AirtimeDataRequestToJson(AirtimeDataRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('phoneNumber', instance.phoneNumber);
  writeNotNull('serviceProviderCode', instance.serviceProviderCode);
  writeNotNull('minorCreditAmount', instance.minorCreditAmount);
  writeNotNull('name', instance.name);
  writeNotNull('location', instance.location);
  return val;
}
