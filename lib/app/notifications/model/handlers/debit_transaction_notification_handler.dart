import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_dao.dart';
import 'package:moniepoint_flutter/app/accounts/views/transaction_history_list_item.dart';
import 'package:moniepoint_flutter/app/notifications/app_notification_service.dart';
import 'package:moniepoint_flutter/app/notifications/model/data/remote_notification_message.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/notification_handler.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/notifications/view/notification_wrapper.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/views/moniepoint_scaffold.dart';
import 'package:moniepoint_flutter/main.dart';

part 'debit_transaction_notification_handler.g.dart';

///DebitTransactionNotificationHandler
///
///
class DebitCreditTransactionNotificationHandler extends NotificationHandler {

  DebitCreditTransactionNotificationHandler._();

  static final DebitCreditTransactionNotificationHandler _instance = DebitCreditTransactionNotificationHandler._();

  factory DebitCreditTransactionNotificationHandler() => _instance;

  RemoteNotificationMessage? message;
  TransactionDao? transactionDao;

  @override
  void setRemoteNotificationMessage(RemoteNotificationMessage message) {
    this.message = message;
  }

  @override
  Future<void> notify(int notificationType) async {
    if(!_isNotificationMessageValid()) return;
    if(notificationType == NotificationHandler.BACKGROUND_MESSAGE) {
      _onBackgroundNotification();
    } else if(notificationType == NotificationHandler.FOREGROUND_MESSAGE) {
      _onForegroundNotification();
    }
  }

  Future<void> _persistDataLocally() async {
    this.transactionDao = GetIt.I<TransactionDao>();
    final data = message?.data as DebitCreditTransactionMessage?;

    if(data == null || this.transactionDao == null) return;

    final accountTransaction = data.transactionObj;

    if(accountTransaction != null) {
      await this.transactionDao?.insertItem(accountTransaction);
    }
  }

  void _onForegroundNotification() {
    final context = navigatorKey.currentContext;
    if(context == null) return;

    final transactionData = message?.data as DebitCreditTransactionMessage?;

    if(transactionData == null) return;

    final accountTransaction = transactionData.transactionObj;

    MoniepointAppMessenger.of(context).showInAppNotification(
      NotificationBanner(
          content: DebitCreditNotificationItem(
            accountTransaction: accountTransaction,
            title: message?.title ?? "",
            description: message?.description ?? "",
            onClick: handle,
          )
      )
    );
  }

  void _onBackgroundNotification() {
    const AndroidNotificationDetails androidSpecifics = AndroidNotificationDetails(
        "transactions", "Moniepoint Transactions", importance: Importance.max, priority: Priority.high
    );

   IOSNotificationDetails iosSpecifics = IOSNotificationDetails(
        badgeNumber: 0,
        subtitle: message?.messageType == MessageType.DEBIT_TRANSACTION_ALERT
            ? "Debit Transaction" : "Credit Transaction"
    );

    NotificationDetails platformSpecifics = NotificationDetails(
        android: (Platform.isAndroid == true) ? androidSpecifics : null,
        iOS: (Platform.isIOS == true) ? iosSpecifics : null
    );

    final data = message?.data as DebitCreditTransactionMessage?;

    notificationPlugin.show(
        1,
        message?.title ?? "",
        message?.description ?? "",
        platformSpecifics,
        payload: jsonEncode(message?.toJson((value) => data?.toJson() ?? {}))
    );
  }

  @override
  Future<void> handle() async {
    final context = navigatorKey.currentContext;
    if(context == null) return;

    print("Handling Notification!!!!!!");

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    final transactionMessage = message?.data as DebitCreditTransactionMessage?;
    final item = transactionMessage?.transactionObj;

    if(UserInstance().getUser() != null && item != null) {

      //check if the account number is the same as the current logged-in user
      await _persistDataLocally();

      await Future.delayed(Duration(milliseconds: 600));

      await Navigator.of(context).pushNamed(
          Routes.ACCOUNT_TRANSACTIONS_DETAIL, arguments: {
        "transactionRef": item.transactionRef,
        "accountNumber": item.accountNumber
      });
    } else {
      print("Saving Notification Handling Notification!!!!!!");
      saveNotificationForLater(message!.messageType!, message!);
    }
  }

  bool _isNotificationMessageValid() {
    return message?.title != null
        && message?.title?.isNotEmpty == true
        && message?.description != null
        && message?.description?.isNotEmpty == true;
  }

  static RemoteNotificationMessage buildRemoteNotificationMessage(Object? notificationData) {
    if(notificationData is Map<String, dynamic>) {
      print("Getting the actual data");
      final dataMessage = notificationData["dataMessage"] ?? notificationData;
      return RemoteNotificationMessage.fromJson(dataMessage, (json) => DebitCreditTransactionMessage.fromJson(json));
    } else if(notificationData is RemoteNotificationMessage) {
      return notificationData;
    }
    return RemoteNotificationMessage.fromJson({}, (json) => {});
  }

}

class DebitCreditNotificationItem extends StatelessWidget {

  DebitCreditNotificationItem({
    required this.accountTransaction,
    required this.title,
    required this.description,
    required this.onClick
  });

  final AccountTransaction? accountTransaction;
  final String title;
  final String description;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 13, right: 13, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0XFF000000).withOpacity(0.2),
                offset: Offset(0, 13),
                blurRadius: 21
            )
          ]
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onClick,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                TransactionHistoryListItem.initialView(accountTransaction?.type ?? TransactionType.UNKNOWN),
                SizedBox(width: 18,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 2,),
                    Text(
                      description,
                      style: TextStyle(color: Colors.deepGrey, fontSize: 12, fontWeight: FontWeight.normal),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}


@JsonSerializable()
class DebitCreditTransactionMessage {
  final AccountTransaction? transactionObj;

  DebitCreditTransactionMessage({
    this.transactionObj
  });

  factory DebitCreditTransactionMessage.fromJson(Object? data) {
    final mapData = data as Map<String, dynamic>;
    final transactionObjData = mapData["transactionObj"];
    final transactionObj = (transactionObjData is String)
        ? jsonDecode(transactionObjData) as Map<String, dynamic>
        : transactionObjData;
    final finalMap = Map<String, dynamic>.from(mapData);
    finalMap["transactionObj"] = transactionObj;
    return _$DebitCreditTransactionMessageFromJson(finalMap);
  }
  Map<String, dynamic> toJson() => _$DebitCreditTransactionMessageToJson(this);
}