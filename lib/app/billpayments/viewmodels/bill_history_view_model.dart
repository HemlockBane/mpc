import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/airtime/model/airtime_service_delegate.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillHistoryViewModel extends BaseViewModel {
  late final BillServiceDelegate _delegate;

  BillHistoryViewModel({
    BillServiceDelegate? delegate,
  }) {
    this._delegate = delegate ?? GetIt.I<BillServiceDelegate>();
  }

  PagingSource<int, BillTransaction> getPagedHistoryTransaction() {
    return _delegate.getBillHistory(FilterResults.defaultFilter());
  }
}
