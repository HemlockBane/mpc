import 'package:json_annotation/json_annotation.dart';

part 'prompt_image.g.dart';

@JsonSerializable()
class PromptImage {
  String? name;
  String? type;
  String? svgText;
  String? uuidRef;

  PromptImage(this.name, this.type, this.svgText, this.uuidRef);

  factory PromptImage.fromJson(Object? data) =>
      _$PromptImageFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PromptImageToJson(this);

  bool get isSvg => this.type == "SVG";
  bool get isPng => this.type == "PNG" && this.uuidRef != null;
}
