import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/airtime/model/airtime_service_delegate.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class ServiceProviderViewModel extends BaseViewModel {
  late final AirtimeServiceDelegate _delegate;

  ServiceProviderViewModel({
    AirtimeServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<AirtimeServiceDelegate>();
  }

  Stream<Resource<List<AirtimeServiceProvider>>> getAirtimeServiceProviders() {
    return _delegate.getServiceProviders().map((event) {
      if(event is Loading || event is Success){
        print('data--->>> ${event.data?.length.toString()}');
      }
      return event;
    });
  }

  Stream<Resource<List<AirtimeServiceProvider>>> getDataServiceProviders() {
    return _delegate.getDataServiceProviders().map((event) {
      if(event is Loading || event is Success) {
        print('data--->>> ${event.data?.length.toString()}');
      }
      return event;
    });
  }

  Stream<Resource<List<AirtimeServiceProviderItem>>> getServiceProviderItem(String billerId) {
    return _delegate.getServiceProviderItems(billerId).map((event) {
      if(event is Loading || event is Success){
        print('data--->>> ${event.data?.length.toString()}');
      }
      return event;
    });
  }

}