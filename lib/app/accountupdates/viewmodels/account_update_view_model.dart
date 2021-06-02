import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service_delegate.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_update.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/customer_detail_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/additional_info_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_address_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_identification_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/next_of_kin_form.dart';
import 'package:moniepoint_flutter/core/lazy.dart';
import 'package:moniepoint_flutter/core/models/file_uuid.dart';
import 'package:moniepoint_flutter/core/models/services/location_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AccountUpdateViewModel extends BaseViewModel {

  final _addressForm = lazy(() => CustomerAddressForm(requiresMailingAddress: true));
  CustomerAddressForm get addressForm => _addressForm.value;

  final _additionalInfoForm = lazy(() => AdditionalInfoForm());
  AdditionalInfoForm get additionalInfoForm => _additionalInfoForm.value;

  final _identificationForm = lazy(() => CustomerIdentificationForm());
  CustomerIdentificationForm get identificationForm => _identificationForm.value;

  final _nextOfKinForm = lazy(() => NextOfKinForm());
  NextOfKinForm get nextOfKinForm => _nextOfKinForm.value;

  AccountUpdateViewModel({CustomerServiceDelegate? customerServiceDelegate, LocationServiceDelegate? locationServiceDelegate}) {
    this._locationServiceDelegate = locationServiceDelegate ?? GetIt.I<LocationServiceDelegate>();
    this._customerServiceDelegate = customerServiceDelegate ?? GetIt.I<CustomerServiceDelegate>();
  }

  late final LocationServiceDelegate _locationServiceDelegate;
  late final CustomerServiceDelegate _customerServiceDelegate;

  final List<Nationality> nationalities = [];
  final List<Tier> tiers = [];

  final StreamController<Tuple<int, bool>> _pageFormController = StreamController.broadcast();
  Stream<Tuple<int, bool>> get pageFormStream => _pageFormController.stream;

  void moveToNext(int currentIndex, {bool skip = false}) {
    _pageFormController.sink.add(Tuple(currentIndex, skip));
  }

  Stream<Resource<FileUUID>> uploadValidIdentity(String filePath) {
    return _customerServiceDelegate.uploadDocument(File(filePath)).map((event) {
      return event;
    });
  }

  Stream<Resource<FileUUID>> uploadAddressProof(String filePath) {
    return _customerServiceDelegate.uploadDocument(File(filePath)).map((event) {
      return event;
    });
  }

  AccountUpdate _buildAccountUpdateRequest() {
    var customerDetailInfo = (_additionalInfoForm.isInitialized) ? additionalInfoForm.customerInfo : null;

    if(customerDetailInfo != null && _addressForm.isInitialized) {
      customerDetailInfo..addressInfo = addressForm.getAddressInfo;
    }else if(_addressForm.isInitialized && !_additionalInfoForm.isInitialized) {
      customerDetailInfo = CustomerDetailInfo(addressInfo: addressForm.getAddressInfo);
    }

    return AccountUpdate(
      customerDetailInfo: (_additionalInfoForm.isInitialized)
          ? additionalInfoForm.customerInfo
          : null,
      mailingAddressInfo: (_addressForm.isInitialized)
          ? addressForm.getMailingAddressInfo
          : null,
      identificationInfo: (_identificationForm.isInitialized)
          ? identificationForm.identificationInfo
          : null,
      nextOfKinInfo: (_nextOfKinForm.isInitialized)
          ? nextOfKinForm.nextOfKinInfo
          : null
    );
  }

  Stream<Resource<Tier>> checkCustomerEligibility({AccountUpdate? accountUpdate}) {
    final mAccountUpdate = accountUpdate ?? _buildAccountUpdateRequest();
    return _customerServiceDelegate.checkCustomerEligibility(customerId, mAccountUpdate);
  }

  Stream<Resource<Tier>> updateAccount() async* {
    final accountUpdate = _buildAccountUpdateRequest();
    final responseStream = _customerServiceDelegate.updateCustomerInfo(customerId, accountUpdate);
    await for(var resource in responseStream) {
      if(resource is Success) yield* _customerServiceDelegate.checkCustomerEligibility(customerId, accountUpdate);
      else if(resource is Loading) yield Resource.loading(null);
      else if(resource is Error<AccountUpdate>) yield Resource.error(err: ServiceError(message: resource.message ?? ""));
    }
  }

  Stream<Resource<List<Nationality>>> fetchCountries() {
    return _locationServiceDelegate.getCountries().map((event) {
      if(event is Success || event is Loading) {
        if(nationalities.isNotEmpty) return event;
        nationalities.clear();
        nationalities.addAll(event.data ?? []);
        notifyListeners();
      }
      return event;
    });
  }

  @override
  void dispose() {
    _pageFormController.close();
    super.dispose();
  }
}