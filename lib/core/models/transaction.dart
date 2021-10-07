import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
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

  String? getSinkAccountBankName() {
    return null;
  }

  String? getSinkAccountBankCode() {
    return null;
  }

  String getSourceAccountBank();

  String getPaymentInterval();

  String getBatchKey();

  String getCurrencyCode();


  String transactionDateToString({String format = "d MMM. yy | h:mm a", int? transactionDate}) {
    return DateFormat(format).format(
        DateTime.fromMillisecondsSinceEpoch(transactionDate ?? getInitiatedDate())
    );
  }

  String transactionTypeToString() {
    return describeEnum(getType());
  }

}

enum TransactionType { DEBIT, CREDIT, UNKNOWN }
