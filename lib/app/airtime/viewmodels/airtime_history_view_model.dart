import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/airtime/model/airtime_service_delegate.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AirtimeHistoryViewModel extends BaseViewModel {
  late final AirtimeServiceDelegate _delegate;

  AirtimeHistoryViewModel({
    AirtimeServiceDelegate? delegate,
  }) {
    this._delegate = delegate ?? GetIt.I<AirtimeServiceDelegate>();
  }

  PagingSource<int, AirtimeTransaction> getPagedHistoryTransaction() {
    return _delegate.getAirtimeHistory(FilterResults.defaultFilter());
  }
}
