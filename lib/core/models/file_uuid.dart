import 'package:json_annotation/json_annotation.dart';

part 'file_uuid.g.dart';

@JsonSerializable()
class FileUUID {
  @JsonKey(name:"uuid")
  String? uuid;

  FileUUID();

  factory FileUUID.fromJson(Object? data) => _$FileUUIDFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FileUUIDToJson(this);

}