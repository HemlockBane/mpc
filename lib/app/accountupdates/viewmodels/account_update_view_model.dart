import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service_delegate.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_update.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/address_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/cba_customer_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/customer_detail_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/additional_info_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_address_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_identification_form.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/next_of_kin_form.dart';
import 'package:moniepoint_flutter/core/lazy.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/file_uuid.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/services/location_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
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

  final StreamController<bool> _loadingStateController = StreamController.broadcast();
  Stream<bool> get loadingState => _loadingStateController.stream;

  AccountUpdateViewModel({
    AccountServiceDelegate? accountServiceDelegate,
    CustomerServiceDelegate? customerServiceDelegate,
    LocationServiceDelegate? locationServiceDelegate,
    FileManagementServiceDelegate? fileServiceDelegate}): super(accountServiceDelegate: accountServiceDelegate) {
    this._locationServiceDelegate = locationServiceDelegate ?? GetIt.I<LocationServiceDelegate>();
    this._customerServiceDelegate = customerServiceDelegate ?? GetIt.I<CustomerServiceDelegate>();
    this._fileServiceDelegate = fileServiceDelegate ?? GetIt.I<FileManagementServiceDelegate>();
  }

  late final LocationServiceDelegate _locationServiceDelegate;
  late final CustomerServiceDelegate _customerServiceDelegate;
  late final FileManagementServiceDelegate _fileServiceDelegate;

  late final Map<String, bool Function()> _flagNameToFormValidity = {
    Flags.ADDITIONAL_INFO : () =>  _additionalInfoForm.isInitialized && _additionalInfoForm.value.isFormValid ,
    Flags.IDENTIFICATION_INFO :  () => _identificationForm.isInitialized && _identificationForm.value.isFormValid ,
    Flags.IDENTIFICATION_PROOF :  () => _identificationForm.isInitialized && _identificationForm.value.isFormValid ,
    Flags.ADDRESS_INFO :  () => _addressForm.isInitialized && _addressForm.value.isFormValid ,
    Flags.ADDRESS_PROOF :  () => _addressForm.isInitialized &&  _addressForm.value.getAddressInfo.utilityBillUUID != null,
    Flags.NEXT_OF_KIN_INFO :  () => _nextOfKinForm.isInitialized && _nextOfKinForm.value.isFormValid ,
  };

  final List<Nationality> nationalities = [];
  final List<Tier> tiers = [];

  final StreamController<Tuple<int, bool>> _pageFormController = StreamController.broadcast();
  Stream<Tuple<int, bool>> get pageFormStream => _pageFormController.stream;

  void moveToNext(int currentIndex, {bool skip = false}) {
    _pageFormController.sink.add(Tuple(currentIndex, skip));
  }

  Stream<Resource<FileUUID>> uploadValidIdentity(String filePath) {
    return _customerServiceDelegate.uploadDocument(File(filePath));
  }

  Stream<Resource<FileUUID>> uploadAddressProof(String filePath) {
    return _customerServiceDelegate.uploadDocument(File(filePath));
  }

  Stream<Resource<List<Tier>>> getOnBoardingSchemes({bool fetchFromRemote = true}) {
    return _customerServiceDelegate.getSchemes(fetchFromRemote: fetchFromRemote).map((event) {
      if(this.tiers.isEmpty && (event is Success || event is Loading)) {
        this.tiers.clear();
        this.tiers.addAll(event.data ?? []);
      }
      return event;
    });
  }

  Stream<Resource<CBACustomerInfo>> getCustomerInfo() {
    return _customerServiceDelegate.getCustomerInfo(customerId);
  }

  AccountUpdate _buildAccountUpdateRequest() {
    var customerDetailInfo = (_additionalInfoForm.isInitialized) ? additionalInfoForm.customerInfo : null;

    if(customerDetailInfo != null && _addressForm.isInitialized) {
      customerDetailInfo..addressInfo = addressForm.getAddressInfo;
    } else if(_addressForm.isInitialized && !_additionalInfoForm.isInitialized) {
      customerDetailInfo = CustomerDetailInfo(addressInfo: addressForm.getAddressInfo);
    }

    if(customerDetailInfo != null && !_addressForm.isInitialized) {
      //TODO this is just plain useless but the api requires it this way to cover the backend null-pointer exception
      customerDetailInfo..addressInfo = AddressInfo();
    }

    //The customerID is present and the form is valid and isn't skipped
    final isCustomerIdValid = _identificationForm.isInitialized
        && identificationForm.isFormValid
        && !identificationForm.isSkipped;

    return AccountUpdate(
      customerDetailInfo: (_additionalInfoForm.isInitialized || customerDetailInfo != null)
          ? customerDetailInfo
          : null,
      mailingAddressInfo: (_addressForm.isInitialized && addressForm.isFormValid)
          ? addressForm.mailingAddressForm?.isFormValid == true ? addressForm.getMailingAddressInfo : null
          : null,
      identificationInfo: isCustomerIdValid ? identificationForm.identificationInfo : null,
      nextOfKinInfo: (_nextOfKinForm.isInitialized && nextOfKinForm.isFormValid)
          ? nextOfKinForm.nextOfKinInfo
          : null
    );
  }

  void setIsLoading(bool isLoading) {
    this._loadingStateController.sink.add(isLoading);
  }

  Stream<Resource<Tier>> checkCustomerEligibility({AccountUpdate? accountUpdate, bool updateStatus = false}) async* {
    final mAccountUpdate = accountUpdate ?? _buildAccountUpdateRequest();
    final updateStatusStream = accountServiceDelegate!.updateAllAccountStatus();
    final customerEligibilityStream = _customerServiceDelegate.checkCustomerEligibility(
        customerId, mAccountUpdate
    );

    await for(var resource in customerEligibilityStream) {
      if(resource is Success)  {
        if(!updateStatus) {
          yield resource;
          break;
        } else {
          yield* updateStatusStream.map((event) {
            if(event is Loading) return Resource.loading(null);
            return resource;
          });
          break;
        }
      }
      else if(resource is Loading) yield Resource.loading(null);
      else if(resource is Error<Tier>) yield Resource.error(err: ServiceError(message: resource.message ?? ""));
    }
  }

  void _cleanUpForms() {
    if(_addressForm.isInitialized) addressForm.resetForm();
    if(_nextOfKinForm.isInitialized) nextOfKinForm.resetForm();
  }

  Stream<Resource<Tier>> updateAccount() async* {
    final accountUpdate = _buildAccountUpdateRequest();
    final responseStream = _customerServiceDelegate.updateCustomerInfo(customerId, accountUpdate);
    await for(var resource in responseStream) {
      if(resource is Success) {
        //Do clean up
        _cleanUpForms();
        yield* checkCustomerEligibility(accountUpdate: accountUpdate, updateStatus: true);
      }
      else if(resource is Loading) yield Resource.loading(null);
      else if(resource is Error<AccountUpdate>) yield Resource.error(err: ServiceError(message: resource.message ?? ""));
    }
  }

  Stream<Resource<bool>> loadPageDependencies() async* {
    final countriesStream = _locationServiceDelegate.getCountries(fetchFromRemote: false);
    await for(var resource in countriesStream) {
      if(resource is Success || resource is Loading) {
        if(resource.data?.isNotEmpty == true) {
          //Save nationalities
          nationalities.clear();
          nationalities.addAll(resource.data ?? []);

          yield* getOnBoardingSchemes().map((event) {
            if(event is Success) return Resource.success(true);
            else if (event is Loading) return Resource.loading(false);
            final error = event as Error<List<Tier>>;
            return Resource.error(err: ServiceError(message: error.message ?? ""));
          });
        } else {
          yield Resource.loading(false);
        }
      } else if(resource is Error<List<Nationality>>){
        yield Resource.error(err: ServiceError(message: resource.message ?? ""));
      }
    }
  }

  Stream<Resource<FileResult>> downloadUploadedDocument(String? fileUUID) {
    if (fileUUID == null) return Stream.empty();
    return _fileServiceDelegate.getFileByUUID(fileUUID, shouldFetchRemote: false);
  }

  double getFormWeightedProgress() {
    //The Flags in account status should take priority over what's in customer object due to refresh
    var progress = 0.0;

    final status = UserInstance().accountStatus;
    final flags = status?.listFlags() ?? customer?.listFlags(); // ?: return progress

    if (flags == null) return progress;

    //We are simply calculating the progress the user has made filling the form for update
    //Thus: the progress is inclusive of what has earlier been sent/approved and what
    //the user has currently filled and validated on the device
    flags.where((element) => element != null).forEach((element) {
      if (_flagNameToFormValidity.containsKey(element!.flagName)) {
        final fn = _flagNameToFormValidity[element.flagName];
        if (fn?.call() == true) {
          progress += element.weight;
        } else if (element.status) {
          progress += element.weight;
        }
      } else {
        if (element.flagName == Flags.BVN_VERIFIED && element.status) {
          //has the user graced past tier 1? we can get the next tier and confirm if qualified
          final mTiers = tiers;
          if ((mTiers.isEmpty || mTiers.length == 1)) {
            //TODO
          } else {
            final nextTier = mTiers[1];
            progress += (nextTier.isQualified()) ? element.weight : 0;
          }
        } else
          (element.status) ? progress += element.weight : progress = progress;
      }
    });
    return progress;
  }

  @override
  void dispose() {
    _loadingStateController.close();
    _pageFormController.close();
    if(_addressForm.isInitialized) addressForm.dispose();
    if(_identificationForm.isInitialized) identificationForm.dispose();
    if(_additionalInfoForm.isInitialized) additionalInfoForm.dispose();
    if(_nextOfKinForm.isInitialized) nextOfKinForm.dispose();
    super.dispose();
  }
}