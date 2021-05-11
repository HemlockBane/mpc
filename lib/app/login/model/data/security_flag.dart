import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

part 'security_flag.g.dart';

@JsonSerializable()
class SecurityFlags {
  final bool setPassword;
  final bool changePassword;
  final bool setTransactionPin;
  final bool changeTransactionPin;
  final bool setLoginPin;
  final bool changeLoginPin;
  final bool setFingerprint;
  final bool setSecurityQuestion;
  final bool showMessage;
  final bool changeDevice;
  final bool addDevice;
  final bool denyAccess;

  Queue<SecurityFlag>? _queue;

  SecurityFlags(
      this.setPassword,
      this.changePassword,
      this.setTransactionPin,
      this.changeTransactionPin,
      this.setLoginPin,
      this.changeLoginPin,
      this.setFingerprint,
      this.setSecurityQuestion,
      this.showMessage,
      this.changeDevice,
      this.addDevice,
      this.denyAccess
      );

  factory SecurityFlags.fromJson(Object? data) => _$SecurityFlagsFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SecurityFlagsToJson(this);

  Queue<SecurityFlag> requiredFlagToQueue() {
    _queue = (_queue == null) ? Queue() : _queue;
    if (this.setPassword) _queue?.add(SecurityFlag.SET_PASSWORD);
    if (this.changePassword) _queue?.add(SecurityFlag.CHANGE_PASSWORD);
    if (this.setTransactionPin) _queue?.add(SecurityFlag.SET_TRANSACTION_PIN);
    if (this.changeTransactionPin) _queue?.add(SecurityFlag.CHANGE_TRANSACTION_PIN);
    if (this.setLoginPin) _queue?.add(SecurityFlag.SET_LOGIN_PIN);
    if (this.changeLoginPin) _queue?.add(SecurityFlag.CHANGE_LOGIN_PIN);
    if (this.setFingerprint) _queue?.add(SecurityFlag.SET_FINGER_PRINT);
    if (this.setSecurityQuestion) _queue?.add(SecurityFlag.SET_SECURITY_QUESTION);
    if (this.showMessage) _queue?.add(SecurityFlag.SHOW_MESSAGE);
    if (this.changeDevice) _queue?.add(SecurityFlag.CHANGE_DEVICE);
    if (this.addDevice) _queue?.add(SecurityFlag.ADD_DEVICE);
    if (this.denyAccess) _queue?.add(SecurityFlag.DENY_ACCESS);
    return _queue!;
  }
}

enum SecurityFlag {
  SET_PASSWORD,
  CHANGE_PASSWORD,
  SET_TRANSACTION_PIN,
  CHANGE_TRANSACTION_PIN,
  SET_LOGIN_PIN,
  CHANGE_LOGIN_PIN,
  SET_FINGER_PRINT,
  SET_SECURITY_QUESTION,
  SHOW_MESSAGE,
  CHANGE_DEVICE,
  ADD_DEVICE,
  DENY_ACCESS
}