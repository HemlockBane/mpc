import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';

part 'client_error.g.dart';

@JsonSerializable()
class ClientError {
  ClientError({
    this.code,
    this.message
  });

  String? code;
  String? message;

  factory ClientError.fromJson(Map<String, dynamic> data) => _$ClientErrorFromJson(data);
  Map<String, dynamic> toJson() => _$ClientErrorToJson(this);
}
