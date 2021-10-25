import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_dao.dart';
import 'package:moniepoint_flutter/app/notifications/app_notification_service.dart';
import 'package:moniepoint_flutter/app/notifications/model/data/remote_notification_message.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/notification_handler.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/main.dart';

part 'credit_transaction_notification_handler.g.dart';

///DebitTransactionNotificationHandler
///
///
class CreditTransactionNotificationHandler extends NotificationHandler {

  CreditTransactionNotificationHandler();

  RemoteNotificationMessage? message;
  TransactionDao? transactionDao;

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
    final data = message?.data as CreditTransactionMessage?;

    if(data == null || this.transactionDao == null) return;

    final accountTransaction = data.transactionObj;
    if(accountTransaction != null) {
      await this.transactionDao?.insertItem(accountTransaction);
    }
  }

  void _onForegroundNotification() {
    final context = navigatorKey.currentContext;
    if(context == null) return;

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showMaterialBanner(
         MaterialBanner(
             leading: SvgPicture.asset("res/drawables/ic_moniepoint_cube_alt.svg"),
             content: Column(
               children: [
                 Text(message?.title ?? ""),
                 SizedBox(height: 2),
                 Text(message?.description ?? "")
               ],
             ),
             actions: <Widget>[
               TextButton(
                   onPressed: () => handle(),
                   child: Text("View")
               ),
               TextButton(
                   onPressed: () {
                     ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                   },
                   child: Text("Dismiss")
               ),
             ]
         )
    );
  }

  void _onBackgroundNotification() {
    const AndroidNotificationDetails androidSpecifics = AndroidNotificationDetails(
        "transactions", "Moniepoint Transactions", importance: Importance.max, priority: Priority.high
    );

    const IOSNotificationDetails iosSpecifics = IOSNotificationDetails(
        badgeNumber: 0, subtitle: "Credit Transaction"
    );

    NotificationDetails platformSpecifics = NotificationDetails(
        android: (Platform.isAndroid == true) ? androidSpecifics : null,
        iOS: (Platform.isIOS == true) ? iosSpecifics : null
    );

    final data = message?.data as CreditTransactionMessage?;

    notificationPlugin.show(
        1,
        message?.title,
        message?.description ?? "",
        platformSpecifics,
        payload: jsonEncode(message?.toJson((value) => data?.toJson() ?? {}))
    );
  }

  @override
  Future<void> handle() async {
    final context = navigatorKey.currentContext;
    if(context == null) return;

    final transactionMessage = message?.data as CreditTransactionMessage?;
    final item = transactionMessage?.transactionObj;

    if(UserInstance().getUser() != null && item != null) {
      await _persistDataLocally();
      Navigator.of(context).pushNamed(
          Routes.ACCOUNT_TRANSACTIONS_DETAIL, arguments: {
            "transactionRef": item.transactionRef,
            "accountNumber": item.accountNumber
          });
    }
  }

  bool _isNotificationMessageValid() {
    return message?.title != null
        && message?.title?.isNotEmpty == true
        && message?.description != null
        && message?.description?.isNotEmpty == true;
  }

  static RemoteNotificationMessage buildRemoteNotificationMessage(Map<String, dynamic> notificationData) {
    final dataMessage = notificationData["dataMessage"] ?? notificationData;
    return RemoteNotificationMessage.fromJson(dataMessage, (json) {
      final data = (json is String) ? jsonDecode(json) : json;
      return CreditTransactionMessage.fromJson(data);
    });
  }

}


@JsonSerializable()
class CreditTransactionMessage {
  final AccountTransaction? transactionObj;

  CreditTransactionMessage({
    this.transactionObj
  });

  factory CreditTransactionMessage.fromJson(Object? data) {
    final mapData = data as Map<String, dynamic>;
    final transactionObjData = mapData["transactionObj"];
    final transactionObj = (transactionObjData is String)
        ? jsonDecode(transactionObjData) as Map<String, dynamic>
        : transactionObjData;
    final finalMap = Map<String, dynamic>.from(mapData);
    finalMap["transactionObj"] = transactionObj;
    return _$CreditTransactionMessageFromJson(finalMap);
  }
  Map<String, dynamic> toJson() => _$CreditTransactionMessageToJson(this);
}