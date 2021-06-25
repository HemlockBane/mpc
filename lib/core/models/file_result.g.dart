// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileResult _$FileResultFromJson(Map<String, dynamic> json) {
  return FileResult(
    base64String: json['base64String'] as String?,
    contentType: json['contentType'] as String?,
  );
}

Map<String, dynamic> _$FileResultToJson(FileResult instance) =>
    <String, dynamic>{
      'base64String': instance.base64String,
      'contentType': instance.contentType,
    };
