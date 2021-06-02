import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';

class FilterResults {

  int startDate = 0;
  int endDate = DateTime.now().millisecondsSinceEpoch;
  Set<TransactionChannel> channels = {};
  Set<TransactionType> types = {};

  FilterResults();

  factory FilterResults.defaultFilter() => FilterResults()
    ..startDate = 0
    ..endDate = DateTime.now().millisecondsSinceEpoch
    ..channels = {
      TransactionChannel.ATM,
      TransactionChannel.KIOSK,
      TransactionChannel.WEB,
      TransactionChannel.MOBILE,
      TransactionChannel.POS,
      TransactionChannel.USSD
    }
    ..types = {TransactionType.CREDIT, TransactionType.DEBIT};
}