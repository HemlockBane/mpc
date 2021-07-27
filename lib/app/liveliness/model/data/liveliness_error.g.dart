// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liveliness_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LivelinessError _$LivelinessErrorFromJson(Map<String, dynamic> json) {
  return LivelinessError(
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => ClientError.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$LivelinessErrorToJson(LivelinessError instance) =>
    <String, dynamic>{
      'errors': instance.errors,
    };
