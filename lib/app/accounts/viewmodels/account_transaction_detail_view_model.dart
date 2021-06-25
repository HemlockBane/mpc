import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/download_transaction_receipt_request_body.dart';
import 'package:moniepoint_flutter/app/accounts/model/transaction_service_delegate.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AccountTransactionDetailViewModel extends BaseViewModel {
  late final TransactionServiceDelegate _delegate;

  AccountTransactionDetailViewModel({
    TransactionServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<TransactionServiceDelegate>();
  }

  Future<AccountTransaction?> getSingleTransactionById(String transRef) {
    return _delegate.getSingleAccountTransaction(transRef);
  }

  Stream<Uint8List> downloadTransactionReceipt(AccountTransaction transaction){
    print(jsonEncode(transaction.metaData));
    return _delegate.downloadTransactionReceipt(DownloadTransactionReceiptRequestBody(
      customerId: customerId,
      transactionRef: transaction.transactionRef,
      metaDataObj: transaction.metaData,
      narration: transaction.narration
    ));
  }

}