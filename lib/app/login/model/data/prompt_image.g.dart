// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromptImage _$PromptImageFromJson(Map<String, dynamic> json) {
  return PromptImage(
    json['name'] as String?,
    json['type'] as String?,
    json['svgText'] as String?,
    json['uuidRef'] as String?,
  );
}

Map<String, dynamic> _$PromptImageToJson(PromptImage instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'svgText': instance.svgText,
      'uuidRef': instance.uuidRef,
    };
