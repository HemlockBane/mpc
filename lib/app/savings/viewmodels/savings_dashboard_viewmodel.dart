import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class SavingsDashboardViewModel extends BaseViewModel {
  late final SavingsProductServiceDelegate _productServiceDelegate;

  SavingsDashboardViewModel({SavingsProductServiceDelegate? productServiceDelegate}) {
    this._productServiceDelegate = productServiceDelegate ?? GetIt.I<SavingsProductServiceDelegate>();
  }

  Stream<Resource<SavingsProduct>> getFlexProduct() {
    return _productServiceDelegate.getFlexProduct();
  }
}