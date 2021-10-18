// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_notification_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteNotificationMessage<T> _$RemoteNotificationMessageFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  return RemoteNotificationMessage<T>(
    title: json['title'] as String?,
    description: json['description'] as String?,
    messageType:
        _$enumDecodeNullable(_$MessageTypeEnumMap, json['messageType']),
    data: _$nullableGenericFromJson(json['data'], fromJsonT),
  );
}

Map<String, dynamic> _$RemoteNotificationMessageToJson<T>(
  RemoteNotificationMessage<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'messageType': _$MessageTypeEnumMap[instance.messageType],
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$MessageTypeEnumMap = {
  MessageType.DEBIT_TRANSACTION_ALERT: 'DEBIT_TRANSACTION_ALERT',
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
