import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/transaction_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class TransactionHistoryViewModel extends BaseViewModel {
  late final TransactionServiceDelegate _delegate;

  TransactionHistoryViewModel({
    TransactionServiceDelegate? delegate,
  }) {
    this._delegate = delegate ?? GetIt.I<TransactionServiceDelegate>();
  }

  PagingSource<int, AccountTransaction> getPagedHistoryTransaction() {
    return _delegate.getPageAccountTransactions(customerAccountId, FilterResults.defaultFilter());
  }
}