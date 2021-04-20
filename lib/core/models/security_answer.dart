import 'package:json_annotation/json_annotation.dart';

part 'security_answer.g.dart';

@JsonSerializable()
class SecurityAnswer {

  @JsonKey(name:"questionId")
  final String? questionId;

  @JsonKey(name:"answer")
  final String? answer;

  SecurityAnswer(this.questionId, this.answer);

  factory SecurityAnswer.fromJson(Map<String, dynamic> data) => _$SecurityAnswerFromJson(data);
  Map<String, dynamic> toJson() => _$SecurityAnswerToJson(this);

}