// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromptHeader _$PromptHeaderFromJson(Map<String, dynamic> json) {
  return PromptHeader(
    json['headerState'] as String?,
    json['image'] == null
        ? null
        : PromptImage.fromJson(json['image'] as Object),
  );
}

Map<String, dynamic> _$PromptHeaderToJson(PromptHeader instance) =>
    <String, dynamic>{
      'headerState': instance.headerState,
      'image': instance.image,
    };
