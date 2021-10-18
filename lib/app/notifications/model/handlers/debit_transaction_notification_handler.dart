import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moniepoint_flutter/app/notifications/app_notification_service.dart';
import 'package:moniepoint_flutter/app/notifications/model/data/remote_notification_message.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/notification_handler.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debit_transaction_notification_handler.g.dart';

///DebitTransactionNotificationHandler
///
///
class DebitTransactionNotificationHandler extends NotificationHandler {

  DebitTransactionNotificationHandler(this.message): super(message);

  final RemoteNotificationMessage? message;

  @override
  Future<void> notify(int notificationType) async {
    if(notificationType == NotificationHandler.BACKGROUND_MESSAGE) {
      _onBackgroundNotification();
    } else if(notificationType == NotificationHandler.FOREGROUND_MESSAGE) {
      _onForegroundNotification();
    }
  }

  void _onForegroundNotification() {
    //TODO pending on design
  }

  void _onBackgroundNotification() {
    const AndroidNotificationDetails androidSpecifics = AndroidNotificationDetails(
        "", "", importance: Importance.max, priority: Priority.high
    );

    const IOSNotificationDetails iosSpecifics = IOSNotificationDetails(
        badgeNumber: 0, subtitle: "Debit Transaction"
    );

    NotificationDetails platformSpecifics = NotificationDetails(
        android: (Platform.isAndroid == true) ? androidSpecifics : null,
        iOS: (Platform.isIOS == true) ? iosSpecifics : null
    );

    notificationPlugin.show(
        1,
        message?.title,
        message?.description ?? "",
        platformSpecifics,
        payload: jsonEncode(message)
    );
  }

  @override
  Future<void> handle() async {
    //When the notification is clicked
  }

  static RemoteNotificationMessage buildRemoteNotificationMessage(Map<String, dynamic> notificationData) {
    final dataMessage = notificationData["dataMessage"] ?? notificationData;
    return RemoteNotificationMessage.fromJson(dataMessage, (json) => DebitTransactionMessage.fromJson(json));
  }

}


@JsonSerializable()
class DebitTransactionMessage {
  final Map<String, dynamic>? transactionObj;

  DebitTransactionMessage({
    this.transactionObj
  });

  factory DebitTransactionMessage.fromJson(Object? data) {
    final mapData = data as Map<String, dynamic>;
    final transactionObjData = mapData["transactionObj"];
    final transactionObj = (transactionObjData is String)
        ? jsonDecode(transactionObjData) as Map<String, dynamic>?
        : transactionObjData;
    mapData["transactionObj"] = transactionObj;
    return _$DebitTransactionMessageFromJson(mapData);
  }
  Map<String, dynamic> toJson() => _$DebitTransactionMessageToJson(this);
}