import 'dart:collection';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/model/data/total_savings_balance.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service_delegate.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class FlexSavingsListViewModel extends BaseViewModel {
  late final SavingsProductServiceDelegate _productServiceDelegate;

  FlexSavingsListViewModel({SavingsProductServiceDelegate? productServiceDelegate}) {
    this._productServiceDelegate = productServiceDelegate ?? GetIt.I<SavingsProductServiceDelegate>();
  }

  SavingsProduct? _flexSavingsProduct;
  SavingsProduct? get flexSavingsProduct => _flexSavingsProduct;

  void setSavingsProduct(SavingsProduct product){
    this._flexSavingsProduct = product;
  }

  Stream<Resource<List<FlexSaving>>> getFlexSavings() {
    return _productServiceDelegate.getRunningFlexSavings(customerId);
  }

  Stream<Resource<TotalSavingsBalance>> fetchAllSavingsBalance() {
    if(_flexSavingsProduct?.totalSavingsBalance != null) {
      return Stream.value(Resource.success(_flexSavingsProduct?.totalSavingsBalance));
    }
    return _productServiceDelegate.getAllBalance(customerId).map((event) {
      if(event is Success) {
        this._flexSavingsProduct?.totalSavingsBalance = event.data;
      }
      return event;
    });
  }


}