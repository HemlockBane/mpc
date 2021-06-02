import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/models/DropDownItem.dart';

part 'security_question.g.dart';

@JsonSerializable()
class SecurityQuestion implements DropDownItem {

  final int id;
  final String question;
  @JsonKey(defaultValue: true)
  bool isEnabled = true;

  SecurityQuestion(this.id, this.question);

  factory SecurityQuestion.fromJson(Object? data) => _$SecurityQuestionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SecurityQuestionToJson(this);

  @override
  String getTitle() {
    return question;
  }

  @override
  bool getEnabled() {
    return this.isEnabled;
  }

}