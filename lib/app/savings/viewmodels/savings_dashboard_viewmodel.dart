import 'dart:async';
import 'dart:collection';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
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

  SavingsProduct? _flexSavingsProduct;
  TotalSavingsBalance? _totalSavingsBalance;
  TotalSavingsBalance? get totalSavingsBalance => _totalSavingsBalance;

  final LinkedHashMap<int, AccountBalance> _flexIdToAccountBalance = LinkedHashMap();

  void initialLoad() {
    final streams = [
      _productServiceDelegate.getFreeWithdrawalCount()
    ];
    Future.wait(streams.map((e) async {
      await for(var response in e) {
        if(response is Success) return response.data;
        else if(response is Error) break;
      }
    }));
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

  Stream<Resource<List<FlexSaving>>> getFlexSavings() {
    return _productServiceDelegate.getRunningFlexSavings(customerId).map((event) {
      if(event is Loading || event is Success){
        event.data?.forEach((element) {
          element.accountBalance = _flexIdToAccountBalance[element.id];
        });
      }
      return event;
    });
  }

  Stream<Resource<TotalSavingsBalance>> fetchAllSavingsBalance() {
    if(_totalSavingsBalance != null) {
      return Stream.value(Resource.success(_totalSavingsBalance));
    }
    return _productServiceDelegate.getAllBalance(customerId).map((event) {
      if(event is Success) {
        _totalSavingsBalance = event.data;

        //Set the balance here for each flexSavingId
        _totalSavingsBalance?.flexSavingBalanceList?.forEach((element) {
          _flexIdToAccountBalance[element.savingAccountId!] = element.accountBalance!;
        });
      }
      return event;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}