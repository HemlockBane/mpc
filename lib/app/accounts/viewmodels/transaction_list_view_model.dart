import 'dart:async';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/export_statement_request_body.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accounts/model/transaction_service_delegate.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class TransactionHistoryViewModel extends BaseViewModel {
  late final TransactionServiceDelegate _delegate;
  late final CustomerServiceDelegate _customerServiceDelegate;


  final FilterResults _filterResults = FilterResults.defaultFilter();
  final List<Tier> tiers = [];

  bool _isAccountUpdateCompleted = true;
  bool get isAccountUpdateCompleted => _isAccountUpdateCompleted;

  TransactionHistoryViewModel({TransactionServiceDelegate? delegate, CustomerServiceDelegate? customerServiceDelegate}) {
    this._delegate = delegate ?? GetIt.I<TransactionServiceDelegate>();
    this._customerServiceDelegate = customerServiceDelegate ?? GetIt.I<CustomerServiceDelegate>();
  }

  final _filterableItems = List<FilterItem>.unmodifiable([
    FilterItem(title: "Date"),
    FilterItem(title: "Type"),
    FilterItem(title: "Channel")
  ]);

  List<FilterItem> get filterableItems => _filterableItems;

  StreamController<bool> _transactionHistoryController = StreamController.broadcast();
  Stream<bool> get transactionHistoryUpdateStream => _transactionHistoryController.stream;

  PagingSource<int, AccountTransaction> getPagedHistoryTransaction({int? accountId}) {
    return _delegate.getPageAccountTransactions(accountId ?? customerAccountId, _filterResults);
  }

  Stream<Uint8List> exportStatement(int? startDate, int? endDate, {int? accountId}) {
    return _delegate.exportStatement(ExportStatementRequestBody(
      fileType: "PDF",
      customerAccountId: accountId ?? customerAccountId,
      startDate: startDate ?? 0,
      transactionType: "ALL",
      endDate: endDate ?? DateTime.now().millisecondsSinceEpoch
    ));
  }

  Stream<Resource<List<Tier>>> getTiers() {
    return _customerServiceDelegate.getSchemes(fetchFromRemote: false).map((event) {
      if((event is Success || event is Loading) && event.data?.isNotEmpty == true) {
        this.tiers.clear();
        this.tiers.addAll(event.data ?? []);
      }
      return event;
    });
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

  bool isFilteredList() {
    final channels = filterableItems.elementAt(2).values as List<dynamic>?;
    final types = filterableItems.elementAt(1).values as List<dynamic>?;
    return channels?.isNotEmpty == true// did we filter by channels
        || types?.isNotEmpty == true// did we filter by transaction types
        || _filterResults.startDate > 0;//d
  }

  void resetFilter() {
    _filterableItems.forEach((element) {
      element.isSelected = false;
      element.subTitle = "";
      element.itemCount = 0;
      element.values = null;
    });
    _filterResults.startDate = 0;
    _filterResults.endDate = DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch;
    _filterResults.channels.clear();
    _filterResults.types.clear();
  }

  void update() {
    _transactionHistoryController.add(true);
  }

  void checkAccountUpdate() {
    AccountStatus? accountStatus = UserInstance().accountStatus;
    final flags = accountStatus?.listFlags() ?? customer?.listFlags();
    if (flags == null) return;
    _isAccountUpdateCompleted = flags.where((element) => element?.status != true).isEmpty;
  }

  @override
  void dispose() {
    _transactionHistoryController.close();
    super.dispose();
  }

}
