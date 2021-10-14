import 'package:moniepoint_flutter/core/models/transaction.dart';

class TransactionRequestContract {

  final dynamic intent;
  final TransactionRequestContractType requestType;

  TransactionRequestContract({
    required this.intent,
    required this.requestType
  });

}

enum TransactionRequestContractType {
  REPLAY, BEGIN_TRANSFER
}