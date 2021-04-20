import 'package:json_annotation/json_annotation.dart';

part 'security_question.g.dart';

@JsonSerializable()
class SecurityQuestion {

  final int id;
  final String question;
  @JsonKey(defaultValue: false)
  bool isEnabled = false;

  SecurityQuestion(this.id, this.question);

  factory SecurityQuestion.fromJson(Object? data) => _$SecurityQuestionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SecurityQuestionToJson(this);

}