// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_question_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecurityQuestionRequestBody _$SecurityQuestionRequestBodyFromJson(
    Map<String, dynamic> json) {
  return SecurityQuestionRequestBody()
    ..accountNumber = json['accountNumber'] as String?
    ..username = json['username'] as String?
    ..questionId = json['questionId'] as String?
    ..answer = json['answer'] as String?;
}

Map<String, dynamic> _$SecurityQuestionRequestBodyToJson(
        SecurityQuestionRequestBody instance) =>
    <String, dynamic>{
      'accountNumber': instance.accountNumber,
      'username': instance.username,
      'questionId': instance.questionId,
      'answer': instance.answer,
    };
