import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/model/transfer_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class TransferHistoryViewModel extends BaseViewModel {
  late final TransferServiceDelegate _delegate;

  TransferHistoryViewModel({
    TransferServiceDelegate? delegate,
  }) {
    this._delegate = delegate ?? GetIt.I<TransferServiceDelegate>();
  }

  PagingSource<int, SingleTransferTransaction> getPagedHistoryTransaction() {
    return _delegate.getTransferHistory(customerId, FilterResults.defaultFilter());
  }
}
