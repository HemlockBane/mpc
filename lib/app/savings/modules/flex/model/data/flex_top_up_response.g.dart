// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_top_up_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexTopUpResponse _$FlexTopUpResponseFromJson(Map<String, dynamic> json) {
  return FlexTopUpResponse(
    request: json['request'] == null
        ? null
        : FlexTopUpResponse.fromJson(json['request'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FlexTopUpResponseToJson(FlexTopUpResponse instance) =>
    <String, dynamic>{
      'request': instance.request,
    };
