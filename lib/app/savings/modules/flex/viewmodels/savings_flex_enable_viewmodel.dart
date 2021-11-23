import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service_delegate.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';


class SavingsFlexEnableViewModel extends BaseViewModel {

  late final SavingsProductServiceDelegate _productServiceDelegate;

  bool _isEnablingFlex = false;
  bool get isEnablingFlex => _isEnablingFlex;

  SavingsFlexEnableViewModel({SavingsProductServiceDelegate? productServiceDelegate}) {
    this._productServiceDelegate = productServiceDelegate ?? GetIt.I<SavingsProductServiceDelegate>();
  }

  Stream<Resource<FlexSaving>> enableFlexSavings() {
    return this._productServiceDelegate.enableFlexSaving(customerId);
  }

  void setIsEnablingFlex(bool isEnablingFlex) {
    this._isEnablingFlex = isEnablingFlex;
  }

  @override
  void dispose() {
    super.dispose();
  }

}