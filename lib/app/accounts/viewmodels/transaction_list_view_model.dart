import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/transaction_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class TransactionHistoryViewModel extends BaseViewModel {
  late final TransactionServiceDelegate _delegate;
  final FilterResults _filterResults = FilterResults.defaultFilter();

  final _filterableItems = List<FilterItem>.unmodifiable([
    FilterItem(title: "Date"),
    FilterItem(title: "Type"),
    FilterItem(title: "Channel")
  ]);

  List<FilterItem> get filterableItems => _filterableItems;

  TransactionHistoryViewModel({
    TransactionServiceDelegate? delegate,
  }) {
    this._delegate = delegate ?? GetIt.I<TransactionServiceDelegate>();
  }

  PagingSource<int, AccountTransaction> getPagedHistoryTransaction() {
    return _delegate.getPageAccountTransactions(customerAccountId, _filterResults);
  }

  void setStartAndEndDate(int startDate, int endDate) {
    _filterResults.startDate = startDate;
    _filterResults.endDate = endDate;
  }

  void setChannels(List<TransactionChannel> channels) {
    _filterResults.channels.clear();
    _filterResults.channels.addAll(channels);
  }

  void setTransactionTypes(List<TransactionType> types) {
    _filterResults.types.clear();
    _filterResults.types.addAll(types);
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