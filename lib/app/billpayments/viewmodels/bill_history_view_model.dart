import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillHistoryViewModel extends BaseViewModel {
  late final BillServiceDelegate _delegate;
  late final FileManagementServiceDelegate _fileServiceDelegate;

  final FilterResults _filterResults = FilterResults.defaultFilter();
  FilterResults get filterResults => _filterResults;

  final _filterableItems = List<FilterItem>.unmodifiable([
    FilterItem(title: "Date")
  ]);
  List<FilterItem> get filterableItems => _filterableItems;

  BillHistoryViewModel({
    BillServiceDelegate? delegate,
    FileManagementServiceDelegate? fileServiceDelegate
  }) {
    this._delegate = delegate ?? GetIt.I<BillServiceDelegate>();
    this._fileServiceDelegate = fileServiceDelegate ?? GetIt.I<FileManagementServiceDelegate>();
  }

  PagingSource<int, BillTransaction> getPagedHistoryTransaction() {
    return _delegate.getBillHistory(_filterResults, customerId);
  }

  void setStartAndEndDate(int startDate, int endDate) {
    _filterResults.startDate = startDate;
    _filterResults.endDate = endDate;
  }

  bool  isFilteredList() {
    return _filterResults.startDate > 0;//d
  }

  void resetFilter() {
    _filterableItems.forEach((element) {
      element.isSelected = false;
      element.subTitle = "";
      element.itemCount = 0;
    });
    _filterResults.startDate = 0;
    _filterResults.endDate = DateTime.now().add(Duration(minutes: 1)).millisecondsSinceEpoch;
  }

  Stream<Resource<FileResult>> getFile(String fileUUID) {
    return _fileServiceDelegate.getFileByUUID(fileUUID);
  }

}
