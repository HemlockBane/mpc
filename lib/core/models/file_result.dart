import 'package:json_annotation/json_annotation.dart';

part 'file_result.g.dart';

@JsonSerializable()
class FileResult {
  @JsonKey(name:"base64String")
  String? base64String;

  @JsonKey(name:"contentType")
  String? contentType;

  FileResult({
    this.base64String,
    this.contentType
  });

  factory FileResult.fromJson(Object? data) => _$FileResultFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FileResultToJson(this);

}