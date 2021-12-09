import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/model/data/total_savings_balance.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service_delegate.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class SavingsDashboardViewModel extends BaseViewModel {
  late final SavingsProductServiceDelegate _productServiceDelegate;

  SavingsDashboardViewModel({SavingsProductServiceDelegate? productServiceDelegate}) {
    this._productServiceDelegate = productServiceDelegate ?? GetIt.I<SavingsProductServiceDelegate>();
  }

  StreamController<DashboardState> _dashboardStateController = StreamController.broadcast();
  Stream<DashboardState> get dashboardUpdateStream => _dashboardStateController.stream;

  SavingsProduct? _flexSavingsProduct;

  void update(DashboardState state) {
    _dashboardStateController.sink.add(state);
  }

  SavingsProduct? getFlexSavingsProduct() {
    return _flexSavingsProduct;
  }

  Stream<Resource<SavingsProduct>> _getFlexProduct() {
    return _productServiceDelegate.getFlexProduct();
  }

  Stream<Resource<SavingsProduct>> getRunningFlexSavings() async* {
    final productDetailsStream = _getFlexProduct();
    await for (final flexResource in productDetailsStream) {
      if(flexResource is Loading) {
        if(flexResource.data != null) {
          yield* _getRunningFlexSavings(flexResource.data!);
          break;
        }
        else yield flexResource;
      }
      if(flexResource is Success) {
        if(flexResource.data != null) yield* _getRunningFlexSavings(flexResource.data!);
        else yield flexResource;
      }
      if(flexResource is Error<SavingsProduct>) {
        yield flexResource;
        break;
      }
    }
  }

  Stream<Resource<SavingsProduct>> _getRunningFlexSavings(SavingsProduct product)  {
    this._flexSavingsProduct = product;
    return _productServiceDelegate.getRunningFlexSavings(customerId).map((event) {
      if(event is Loading) return Resource.loading(product.withFlexSavings(event.data));
      if(event is Error<List<FlexSaving>>) {
        return Resource.error(err: ServiceError(message: event.message ?? ""));
      }
      return Resource.success(product.withFlexSavings(event.data));
    });
  }

  Stream<Resource<TotalSavingsBalance>> fetchAllSavingsBalance() {
    return _productServiceDelegate.getAllBalance(customerId).map((event) {
      if(event is Success || event is Error) update(DashboardState.DONE);
      if(event is Success) {
        _flexSavingsProduct?.totalSavingsBalance = event.data;
      }
      return event;
    });
  }

  @override
  void dispose() {
    _dashboardStateController.close();
    super.dispose();
  }
}