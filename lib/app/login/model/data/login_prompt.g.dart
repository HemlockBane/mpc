// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_prompt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginPrompt _$LoginPromptFromJson(Map<String, dynamic> json) {
  return LoginPrompt(
    PromptHeader.fromJson(json['commandPromptHeader'] as Object),
    json['title'] as String?,
    json['message'] as String?,
    json['videoLink'] as String?,
    PromptImage.fromJson(json['displayImage'] as Object),
    (json['navigationList'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$LoginPromptToJson(LoginPrompt instance) =>
    <String, dynamic>{
      'commandPromptHeader': instance.header,
      'title': instance.title,
      'message': instance.message,
      'videoLink': instance.videoLink,
      'displayImage': instance.displayImage,
      'navigationList': instance.navigationList,
    };
