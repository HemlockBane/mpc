import 'package:moniepoint_flutter/app/notifications/model/data/remote_notification_message.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/debit_transaction_notification_handler.dart';

///NotificationHandler
///
///
abstract class NotificationHandler {

  static const int BACKGROUND_MESSAGE = 1;
  static const int FOREGROUND_MESSAGE = 2;

  NotificationHandler(RemoteNotificationMessage? message);

  Future<void> notify(int notificationType) async {}

  Future<void> handle() async {}

  factory NotificationHandler.getInstance(MessageType? messageType, Map<String, dynamic> notificationData) {
    switch(messageType) {
      case MessageType.DEBIT_TRANSACTION_ALERT:
        final remoteNotificationMessage = DebitTransactionNotificationHandler
            .buildRemoteNotificationMessage(notificationData);
        return DebitTransactionNotificationHandler(remoteNotificationMessage);
      default:
        return _DefaultHandler(null);
    }
  }

}




///_DefaultHandler
///
///
class _DefaultHandler extends NotificationHandler {
  _DefaultHandler(RemoteNotificationMessage? message):super(message);
}