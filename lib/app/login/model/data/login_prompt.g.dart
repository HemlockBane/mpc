// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_prompt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginPrompt _$LoginPromptFromJson(Map<String, dynamic> json) {
  return LoginPrompt(
    json['commandPromptHeader'] == null
        ? null
        : PromptHeader.fromJson(json['commandPromptHeader'] as Object),
    json['title'] as String?,
    json['message'] as String?,
    json['videoLink'] as String?,
    json['image'] == null
        ? null
        : PromptImage.fromJson(json['image'] as Object),
    (json['navigationList'] as List<dynamic>?)
        ?.map((e) => NavigationItem.fromJson(e as Object))
        .toList(),
  );
}

Map<String, dynamic> _$LoginPromptToJson(LoginPrompt instance) =>
    <String, dynamic>{
      'commandPromptHeader': instance.header,
      'title': instance.title,
      'message': instance.message,
      'videoLink': instance.videoLink,
      'image': instance.displayImage,
      'navigationList': instance.navigationList,
    };
