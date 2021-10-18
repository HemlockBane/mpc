import 'package:json_annotation/json_annotation.dart';
part 'remote_notification_message.g.dart';

enum MessageType {
  DEBIT_TRANSACTION_ALERT
}

@JsonSerializable(genericArgumentFactories: true)
class RemoteNotificationMessage<T> {
  final String? title;
  final String? description;
  final MessageType? messageType;
  final T? data;

  RemoteNotificationMessage({
    this.title,
    this.description,
    this.messageType,
    this.data
  });

  factory RemoteNotificationMessage.fromJson(Map<String, dynamic> data, T Function(Object? json) fromJsonT) =>
      _$RemoteNotificationMessageFromJson(data, fromJsonT);

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonType) =>
      _$RemoteNotificationMessageToJson(this, toJsonType);
}

