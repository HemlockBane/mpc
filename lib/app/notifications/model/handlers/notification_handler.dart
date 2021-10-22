import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:moniepoint_flutter/app/notifications/model/data/remote_notification_message.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/debit_transaction_notification_handler.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:collection/collection.dart';

///NotificationHandler
///
///
 abstract class NotificationHandler {

  static const int BACKGROUND_MESSAGE = 1;
  static const int FOREGROUND_MESSAGE = 2;

  static const String PENDING_NOTIFICATION_QUEUE = "PENDING_NOTIFICATION_QUEUE";

  final Queue<RemoteNotificationMessage> _pendingNotificationQueue = Queue<RemoteNotificationMessage>();

  NotificationHandler();

  Future<void> notify(int notificationType) async {}

  Future<void> handle() async {}

  void setRemoteNotificationMessage(RemoteNotificationMessage message) {}

  void saveNotificationForLater(MessageType messageType, RemoteNotificationMessage message) {
    final queueString = PreferenceUtil.getValue<String>(PENDING_NOTIFICATION_QUEUE) ?? "";
    final pendingQueue = queueString.split(",").where((element) => element.isNotEmpty).toSet();
    pendingQueue.add(describeEnum(messageType));
    if(pendingQueue.isNotEmpty) {
      PreferenceUtil.saveValue(PENDING_NOTIFICATION_QUEUE, pendingQueue.join(","));
    }
    _pendingNotificationQueue.add(message);
  }

  static Future<void> dispatchPendingNotification() async {
    final queueString = PreferenceUtil.getValue<String>(PENDING_NOTIFICATION_QUEUE) ?? "";
    final pendingQueue = queueString.split(",").toSet();

    if(pendingQueue.isEmpty) return;

    final messageTypeString = pendingQueue.lastOrNull;

    if(messageTypeString == null) return;

    final messageType = enumFromString(MessageType.values, messageTypeString);
    final handler = NotificationHandler.getInstance(messageType, {});
    final pendingMessage = handler._pendingNotificationQueue.firstOrNull;

    if(pendingMessage == null) return;

    handler.setRemoteNotificationMessage(pendingMessage);
    pendingQueue.clear();
    handler._pendingNotificationQueue.clear();
    PreferenceUtil.saveValue(PENDING_NOTIFICATION_QUEUE, "");

    await Future.delayed(Duration(milliseconds: 2000));

    return handler.handle();
  }

  factory NotificationHandler.getInstance(MessageType? messageType, Object notificationData) {
    switch(messageType) {
      case MessageType.DEBIT_TRANSACTION_ALERT:
        final remoteNotificationMessage = DebitCreditTransactionNotificationHandler.buildRemoteNotificationMessage(notificationData);
        final handler = DebitCreditTransactionNotificationHandler()..setRemoteNotificationMessage(remoteNotificationMessage);
        return handler;
      case MessageType.CREDIT_TRANSACTION_ALERT:
        final remoteNotificationMessage = DebitCreditTransactionNotificationHandler.buildRemoteNotificationMessage(notificationData);
        final handler = DebitCreditTransactionNotificationHandler()..setRemoteNotificationMessage(remoteNotificationMessage);
        return handler;
      default:
        return _DefaultHandler(null);
    }
  }

}



///_DefaultHandler
///
///
class _DefaultHandler extends NotificationHandler {
  _DefaultHandler(RemoteNotificationMessage? message);
}