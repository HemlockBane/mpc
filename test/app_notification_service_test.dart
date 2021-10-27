

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moniepoint_flutter/app/notifications/app_notification_service.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/credit_transaction_notification_handler.dart';
import 'package:moniepoint_flutter/app/notifications/model/handlers/notification_handler.dart';
import 'package:test/test.dart';

import 'app_notification_service_test.mocks.dart';


//Scenarios
//What will happen if the server rejects my token i want to register
//What will happen if the server server send a push without data
//....... data without transactionObj
//....... data without a transactionObj that doesn't match what i'm expecting
//....... message without a messageType i don't have


@GenerateMocks([NotificationHandler])
void main() {

  test("Test that we can send a notification and format the message", () async  {

    // final handler = Not
    final data = {
      "data":{
        "dataMessage": "{\n          \"title\": \"DEBIT ALERT\",\n          \"description\": \"NGN500.0 to HAWTHORN SUITES\",\n          \"messageType\": \"DEBIT_TRANSACTION_ALERT\",\n          \"data\": {\n            \"transactionObj\": \"{\\\"amount\\\":500.0,\\\"transactionDate\\\":\\\"2021-10-18T13:40:00.621\\\",\\\"runningBalance\\\":1000,\\\"currencyCode\\\":\\\"NGN\\\",\\\"balanceUpdated\\\":false,\\\"transactionRef\\\":\\\"MPC-ITR-TRF-214018134000PQlD48fZ47Ke\\\",\\\"beneficiaryName\\\":\\\"HAWTHORN SUITES\\\",\\\"beneficiaryBankName\\\":\\\"Moniepoint\\\",\\\"disputable\\\":false,\\\"messageType\\\":\\\"DEBIT_TRANSACTION_ALERT\\\",\\\"userId\\\":1}\"\n          }\n        }"
      }
    };

    await expectLater(
        onBackgroundMessageReceived(RemoteMessage.fromMap(data)),
        completion(null)
    );
  });

  test("Test that notification isn't trigger if dataMessage is missing", () async  {
    // final handler = Not
    final data = {
      "data":{}
    };
    await expectLater(
        onBackgroundMessageReceived(RemoteMessage.fromMap(data)),
        completion(null)
    );
  });

  test("Test that notification isn't triggered if dataMessage format is wrong", () async  {

    final data = {
      "data":{
        "dataMessage": {
          "messageType": "DEBIT_TRANSACTION_ALERT",
          "data": {
            "transactionObj": "{\"amount\":500.0,\"transactionDate\":\"2021-10-18T13:40:00.621\",\"runningBalance\":1000,\"currencyCode\":\"NGN\",\"balanceUpdated\":false,\"transactionRef\":\"MPC-ITR-TRF-214018134000PQlD48fZ47Ke\",\"beneficiaryName\":\"HAWTHORN SUITES\",\"beneficiaryBankName\":\"Moniepoint\",\"disputable\":false,\"messageType\":\"DEBIT_TRANSACTION_ALERT\",\"userId\":1}"
          }
        }
      }
    };
    await expectLater(
        onBackgroundMessageReceived(RemoteMessage.fromMap(data)),
        completion(null)
    );
  });

  test("Test that notification isn't triggered when the message type is unknown", () async  {

    final data = {
      "data":{
        "dataMessage": {
          "messageType": "YADADADA",
        }
      }
    };
    await expectLater(
        onBackgroundMessageReceived(RemoteMessage.fromMap(data)),
        completion(null)
    );
  });

  test("Test that we can parse the data back", () async {
      final remoteMessage = " {\n      \"transactionObj\": {\n        \"accountNumber\": \"5000036360\",\n        \"narration\": \"Transfer to 5000036360 Rolez MFB Okeke Paul _credit\",\n        \"amount\": 110,\n        \"transactionDate\": 20202020202020220,\n        \"runningBalance\": \"2309.00\",\n        \"currencyCode\": \"NGN\",\n        \"transactionChannel\": \"MOBILE\",\n        \"balanceBefore\": \"2199.00\",\n        \"balanceAfter\": \"2199.00\",\n        \"balanceUpdated\": false,\n        \"transactionRef\": \"MPC-ITR-TRF-2147211547156qOzhz8DV4Kk\",\n        \"transactionCategory\": \"TRANSFER\",\n        \"senderIdentifier\": \"5000032355\",\n        \"senderName\": \"AGHO ADRIAN \",\n        \"senderBankName\": \"Moniepoint\",\n        \"senderBankCode\": \"950515\",\n        \"transactionIdentifier\": \"MPC-ITR-TRF-2147211547156qOzhz8DV4Kk\",\n        \"disputable\": false,\n        \"messageType\": \"CREDIT_TRANSACTION_ALERT\",\n        \"userId\": 162,\n        \"expiryDate\": {\n          \"date\": {\n            \"year\": 2021,\n            \"month\": 10,\n            \"day\": 23\n          },\n          \"time\": {\n            \"hour\": 15,\n            \"minute\": 47,\n            \"second\": 20,\n            \"nano\": 666000000\n          }\n        }\n      }\n    }";
      expect(
          CreditTransactionMessage.fromJson(jsonDecode(remoteMessage)),
          equals("expected")
      );
  });


  test("Test that we can dispatch pending notification", () async  {

    // final handler = Not
    final data = {
      "data":{
        "dataMessage": "{\n          \"title\": \"DEBIT ALERT\",\n          \"description\": \"NGN500.0 to HAWTHORN SUITES\",\n          \"messageType\": \"DEBIT_TRANSACTION_ALERT\",\n          \"data\": {\n            \"transactionObj\": \"{\\\"amount\\\":500.0,\\\"transactionDate\\\":\\\"2021-10-18T13:40:00.621\\\",\\\"runningBalance\\\":1000,\\\"currencyCode\\\":\\\"NGN\\\",\\\"balanceUpdated\\\":false,\\\"transactionRef\\\":\\\"MPC-ITR-TRF-214018134000PQlD48fZ47Ke\\\",\\\"beneficiaryName\\\":\\\"HAWTHORN SUITES\\\",\\\"beneficiaryBankName\\\":\\\"Moniepoint\\\",\\\"disputable\\\":false,\\\"messageType\\\":\\\"DEBIT_TRANSACTION_ALERT\\\",\\\"userId\\\":1}\"\n          }\n        }"
      }
    };

    await onBackgroundMessageReceived(RemoteMessage.fromMap(data));
    NotificationHandler.dispatchPendingNotification();
  });

}