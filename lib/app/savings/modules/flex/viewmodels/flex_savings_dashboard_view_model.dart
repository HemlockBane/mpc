import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service_delegate.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_account_balance.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_transaction.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class FlexSavingsDashboardViewModel extends BaseViewModel {
  late final SavingsProductServiceDelegate _flexProductDelegate;

  FlexSaving? _flexSaving;
  FlexSaving? get flexSaving => _flexSaving;

  final FilterResults filterResult = FilterResults.defaultFilter();

  FlexSavingsDashboardViewModel({SavingsProductServiceDelegate? productServiceDelegate}) {
    this._flexProductDelegate = productServiceDelegate ?? GetIt.I<SavingsProductServiceDelegate>();
  }

  void setFlexSaving(FlexSaving flexSaving) {
    this._flexSaving = flexSaving;
  }

  Future<FlexSaving?> getFlexSaving(int flexSavingId){
    return _flexProductDelegate.getSingleFlexSaving(flexSavingId);
  }

  PagingSource<int, FlexTransaction> getPageFlexTransactions(int flexSavingId) {
    return _flexProductDelegate.getPageFlexTransactions(flexSavingId, filterResult);
  }

  Stream<Resource<FlexAccountBalance>> getFlexAccountBalance(int flexSavingId) {
    return _flexProductDelegate.getFlexAccountBalance(flexSavingId).asBroadcastStream().map((event) {
      return event;
    });
  }

}