// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_flags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomFlags _$CustomFlagsFromJson(Map<String, dynamic> json) {
  return CustomFlags(
    verifiedAddress: json['verifiedAddress'] as bool?,
    identification: json['identification'] as bool?,
    nextOfKin: json['nextOfKin'] as bool?,
    address: json['address'] as bool?,
    verifiedIdentification: json['verifiedIdentification'] as bool?,
    signature: json['signature'] as bool?,
  );
}

Map<String, dynamic> _$CustomFlagsToJson(CustomFlags instance) =>
    <String, dynamic>{
      'verifiedAddress': instance.verifiedAddress,
      'identification': instance.identification,
      'nextOfKin': instance.nextOfKin,
      'address': instance.address,
      'verifiedIdentification': instance.verifiedIdentification,
      'signature': instance.signature,
    };
