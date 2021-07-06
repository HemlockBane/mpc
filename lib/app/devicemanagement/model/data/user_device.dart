import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user_device.g.dart';

@JsonSerializable()
class UserDevice {

  UserDevice({
    required this.id,
    this.name,
    this.type,
    this.username,
    required this.deviceId,
    this.fingerprintCipher,
    this.imei,
    this.clientId,
    this.failedLoginAttempts,
    this.blockReason,
    this.blockedBy,
    this.authorized,
    this.os,
    this.model,
    this.lastLogin,
    this.dateAdded,
    this.blocked,
  });

  int id;
  String? name;
  String? type;
  String? username;
  String deviceId;
  String? fingerprintCipher;
  String? imei;
  String? clientId;
  int? failedLoginAttempts;
  String? blockReason;
  String? blockedBy;
  bool? authorized;
  String? os;
  String? model;
  DateTime? lastLogin;
  DateTime? dateAdded;
  bool? blocked;

  factory UserDevice.fromJson(Object? data) {
    final jsonMap = data as Map<String, dynamic>;
    jsonMap["localUser"] = null;
    final a = _$UserDeviceFromJson(jsonMap);

    print(jsonEncode(a));
    return a;
  }
  Map<String, dynamic> toJson() => _$UserDeviceToJson(this);

}