import 'package:moniepoint_flutter/core/models/transaction.dart';

class TransactionRequestContract {

  final Transaction transaction;
  final TransactionRequestContractType requestType;

  TransactionRequestContract({
    required this.transaction,
    required this.requestType
  });

}

enum TransactionRequestContractType {
  REPLAY
}