import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/model/transfer_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class TransferHistoryViewModel extends BaseViewModel {
  late final TransferServiceDelegate _delegate;

  final _filterResults = FilterResults.defaultFilter();
  final _filterableItems = List<FilterItem>.unmodifiable([
    FilterItem(title: "Date")
  ]);

  List<FilterItem> get filterableItems => _filterableItems;

  TransferHistoryViewModel({
    TransferServiceDelegate? delegate,
  }) {
    this._delegate = delegate ?? GetIt.I<TransferServiceDelegate>();
  }

  PagingSource<int, SingleTransferTransaction> getPagedHistoryTransaction() {
    return _delegate.getTransferHistory(customerId, _filterResults);
  }

  void setStartAndEndDate(int startDate, int endDate) {
    _filterResults.startDate = startDate;
    _filterResults.endDate = endDate;
  }

  bool isFilteredList() {
    return _filterResults.startDate > 0;
  }

  void resetFilter() {
    _filterableItems.forEach((element) {
      element.isSelected = false;
      element.subTitle = "";
      element.itemCount = 0;
    });
    _filterResults.startDate = 0;
    _filterResults.endDate = DateTime.now().millisecondsSinceEpoch;
  }

}
