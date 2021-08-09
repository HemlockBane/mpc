import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/login/model/data/prompt_image.dart';

part 'prompt_header.g.dart';

@JsonSerializable()
class PromptHeader {
  String? headerState;
  PromptImage? image;

  PromptHeader(this.headerState, this.image);

  factory PromptHeader.fromJson(Object? data) =>
      _$PromptHeaderFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PromptHeaderToJson(this);
}
