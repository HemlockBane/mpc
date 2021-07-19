
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';

part 'liveliness_error.g.dart';

@JsonSerializable()
class LivelinessError {
  LivelinessError({
    this.errors,
  });

  List<ClientError>? errors;

  factory LivelinessError.fromJson(Map<String, dynamic> data) => _$LivelinessErrorFromJson(data);
  Map<String, dynamic> toJson() => _$LivelinessErrorToJson(this);
}


// @JsonSerializable()
// class FaceMatchError {
//   FaceMatchError({
//     this.message,
//   });
//
//   String? message;
//
//   factory FaceMatchError.fromJson(Map<String, dynamic> data) => _$FaceMatchErrorFromJson(data);
//   Map<String, dynamic> toJson() => _$FaceMatchErrorToJson(this);
// }