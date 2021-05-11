// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liveliness_compare_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LivelinessCompareResponse _$LivelinessCompareResponseFromJson(
    Map<String, dynamic> json) {
  return LivelinessCompareResponse()
    ..reference = json['reference'] as String?
    ..errorMessage = json['errorMessage'] as String?
    ..status = json['status'] as String?;
}

Map<String, dynamic> _$LivelinessCompareResponseToJson(
        LivelinessCompareResponse instance) =>
    <String, dynamic>{
      'reference': instance.reference,
      'errorMessage': instance.errorMessage,
      'status': instance.status,
    };
