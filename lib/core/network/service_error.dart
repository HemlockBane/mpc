import 'package:json_annotation/json_annotation.dart';

part 'service_error.g.dart';

@JsonSerializable()
class ServiceError {
  ServiceError({required this.message, this.code = 0});

  final String message;
  final int? code;

  factory ServiceError.fromJson(Map<String, dynamic> data) => _$ServiceErrorFromJson(data);
  Map<String, dynamic> toJson() => _$ServiceErrorToJson(this);
}
