import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/transaction_service_delegate.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/model/transfer_service_delegate.dart';
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

}