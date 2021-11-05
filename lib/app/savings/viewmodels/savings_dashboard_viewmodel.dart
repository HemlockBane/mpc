import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service_delegate.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/flex_saving.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class SavingsDashboardViewModel extends BaseViewModel {
  late final SavingsProductServiceDelegate _productServiceDelegate;

  SavingsDashboardViewModel({SavingsProductServiceDelegate? productServiceDelegate}) {
    this._productServiceDelegate = productServiceDelegate ?? GetIt.I<SavingsProductServiceDelegate>();
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
    return _productServiceDelegate.getRunningFlexSavings(customerId).map((event) {
      if(event is Loading) return Resource.loading(product.withFlexSavings(event.data));
      if(event is Error<List<FlexSaving>>) {
        return Resource.error(err: ServiceError(message: event.message ?? ""));
      }
      return Resource.success(product.withFlexSavings(event.data));
    });
  }

}