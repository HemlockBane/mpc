import 'package:json_annotation/json_annotation.dart';

part 'edit_device_request.g.dart';

@JsonSerializable()
class EditDeviceRequestBody {
  @JsonKey(name:"deviceId")
  String? deviceId;
  @JsonKey(name:"fingerPrintKey")
  String? fingerPrintKey;
  @JsonKey(name:"name")
  String? name;
  @JsonKey(name:"type")
  String? type;
  @JsonKey(name:"imei")
  String? imei;
  @JsonKey(name:"key")
  String? key;

  EditDeviceRequestBody();

  factory EditDeviceRequestBody.fromJson(Object? data) => _$EditDeviceRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$EditDeviceRequestBodyToJson(this);

}