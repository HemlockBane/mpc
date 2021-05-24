import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';

import 'list_item.dart';

abstract class Transaction extends ListItem {

  int getId();

  double getAmount();

  TransactionType getType();

  PaymentType getPaymentType();

  String getDescription();

  int getInitiatedDate();

  num getTransactionDate();

  String getComment();

  String getInitiatorName();

  num getNextPayDate();

  String getSourceAccountNumber();

  String getSinkAccountName();

  String getSinkAccountNumber();

  String getSourceAccountBank();

  String getPaymentInterval();

  String getBatchKey();

  String getCurrencyCode();

  // WorkFlowType getWorkFlowType();
  //
  // void setWorkFlowType(WorkFlowType type);
}

enum TransactionType { DEBIT, CREDIT }
