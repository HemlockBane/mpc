// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecurityAnswer _$SecurityAnswerFromJson(Map<String, dynamic> json) {
  return SecurityAnswer(
    json['questionId'] as String,
    json['answer'] as String,
  );
}

Map<String, dynamic> _$SecurityAnswerToJson(SecurityAnswer instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'answer': instance.answer,
    };
