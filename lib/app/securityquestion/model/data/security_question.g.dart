// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecurityQuestion _$SecurityQuestionFromJson(Map<String, dynamic> json) {
  return SecurityQuestion(
    json['id'] as int,
    json['question'] as String,
  )..isEnabled = json['isEnabled'] as bool? ?? true;
}

Map<String, dynamic> _$SecurityQuestionToJson(SecurityQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'isEnabled': instance.isEnabled,
    };
