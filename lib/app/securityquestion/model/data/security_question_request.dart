import 'package:json_annotation/json_annotation.dart';

part 'security_question_request.g.dart';

@JsonSerializable()
class SecurityQuestionRequestBody {

  @JsonKey(name:"accountNumber")
  String? accountNumber;

  @JsonKey(name:"username")
  String? username;

  @JsonKey(name:"questionId")
  String? questionId;

  @JsonKey(name:"answer")
  String? answer;

  SecurityQuestionRequestBody();

  factory SecurityQuestionRequestBody.fromJson(Object? data) => _$SecurityQuestionRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SecurityQuestionRequestBodyToJson(this);


  SecurityQuestionRequestBody withAccountNumber(String accountNumber) {
    this.accountNumber = accountNumber;
    return this;
  }

  SecurityQuestionRequestBody withUsername(String username) {
    this.username = username;
    return this;
  }

  SecurityQuestionRequestBody withQuestionId(String questionId) {
    this.questionId = questionId;
    return this;
  }

  SecurityQuestionRequestBody withAnswer(String answer) {
    this.answer = answer;
    return this;
  }

}