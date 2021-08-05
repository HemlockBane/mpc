import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/login/model/data/prompt_header.dart';
import 'package:moniepoint_flutter/app/login/model/data/prompt_image.dart';

part 'login_prompt.g.dart';

@JsonSerializable()
class LoginPrompt {
  @JsonKey(name: "commandPromptHeader")
  PromptHeader header;
  String? title;
  String? message;
  String? videoLink;
  PromptImage displayImage;
  List<String> navigationList;

  LoginPrompt(this.header, this.title, this.message, this.videoLink,
      this.displayImage, this.navigationList);

  factory LoginPrompt.fromJson(Object? data) =>
      _$LoginPromptFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$LoginPromptToJson(this);
}
