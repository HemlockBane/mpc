import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/airtime/model/airtime_service_delegate.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AirtimeHistoryViewModel extends BaseViewModel {
  late final AirtimeServiceDelegate _delegate;

  final FilterResults _filterResults = FilterResults.defaultFilter();
  FilterResults get filterResults => _filterResults;

  final _filterableItems = List<FilterItem>.unmodifiable([
    FilterItem(title: "Date")
  ]);
  List<FilterItem> get filterableItems => _filterableItems;

  AirtimeHistoryViewModel({AirtimeServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<AirtimeServiceDelegate>();
  }

  PagingSource<int, AirtimeTransaction> getPagedHistoryTransaction() {
    return _delegate.getAirtimeHistory(_filterResults);
  }

  void setStartAndEndDate(int startDate, int endDate) {
    _filterResults.startDate = startDate;
    _filterResults.endDate = endDate;
  }


  bool isFilteredList() {
    return _filterResults.startDate > 0;//d
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
