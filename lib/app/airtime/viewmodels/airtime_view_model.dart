import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/airtime/model/airtime_service_delegate.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_data_request.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_request_body.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_type.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/data_topup_request.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/login/model/data/authentication_method.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/airtime_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/device_manager.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AirtimeViewModel extends BaseViewModel with PaymentViewModel {
  late final AirtimeServiceDelegate _delegate;
  late final AirtimeBeneficiaryServiceDelegate _beneficiaryServiceDelegate;
  late final DeviceManager _deviceManager;
  late final FileManagementServiceDelegate _fileServiceDelegate;

  PurchaseType _purchaseType = PurchaseType.AIRTIME;
  PurchaseType get purchaseType => _purchaseType;

  AirtimeServiceProviderItem? _dataPlan;
  AirtimeServiceProviderItem? get dataPlan => _dataPlan;

  List<AirtimeServiceProviderItem> _dataProviderItems = [];
  List<AirtimeServiceProviderItem> get dataProviderItems => _dataProviderItems;

  AirtimeViewModel({AirtimeServiceDelegate? delegate,
    AirtimeBeneficiaryServiceDelegate? beneficiaryServiceDelegate,
    DeviceManager? deviceManager,
    FileManagementServiceDelegate? fileManagementServiceDelegate
  }) {
    this._delegate = delegate ?? GetIt.I<AirtimeServiceDelegate>();
    this._beneficiaryServiceDelegate = beneficiaryServiceDelegate ?? GetIt.I<AirtimeBeneficiaryServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
    this._fileServiceDelegate = fileManagementServiceDelegate ?? GetIt.I<FileManagementServiceDelegate>();
  }

  Stream<Resource<List<AirtimeBeneficiary>>> getFrequentBeneficiaries() {
    return _beneficiaryServiceDelegate.getFrequentBeneficiaries();
  }

  Stream<Resource<List<AirtimeServiceProviderItem>>> getServiceProviderItems(String billerId) {
    return _delegate.getServiceProviderItems(billerId).map((event) {
      if((event is Success || event is Loading) && (_dataProviderItems.isEmpty && event.data?.isNotEmpty == true)) {
        _dataProviderItems.clear();
        _dataProviderItems.addAll(event.data ?? []);
      }
      return event;
    });
  }

  void setPurchaseType(PurchaseType purchaseType) => this._purchaseType = purchaseType;
  void setServiceProviderItem(AirtimeServiceProviderItem? item) {
    this._dataPlan = item;
    checkValidity();
  }

  @override
  void setSourceAccount(UserAccount? userAccount){
    super.setSourceAccount(userAccount);
    checkValidity();
  }

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    this.checkValidity();
  }

  @override
  bool validityCheck() {
    if(sourceAccount == null) return false;
    if(this.purchaseType == PurchaseType.DATA) {
      if(this.dataPlan == null) return false;
      final isAmountFixed = this.dataPlan?.priceFixed == true;
      final dataPlanAmount =  this.dataPlan?.amount ?? 0;
      return (isAmountFixed) ? this.amount == (dataPlanAmount /100): this.amount != null && this.amount! > 0;
    }
    return this.amount != null && (this.amount ?? 0) >= 50;
  }

  String _cleansePhoneNumber() {
    return beneficiary?.getBeneficiaryDigits().replaceAll(RegExp("[^0-9]"), "") ?? "";
  }

  Stream<Resource<TransactionStatus>> doPayment() {
    final requestBody = AirtimePurchaseRequestBody();
    final dataTopUpRequest = DataTopUpRequest();
    final airtimeRequest = AirtimeDataRequest();

    switch(this.purchaseType){
      case PurchaseType.AIRTIME:
        airtimeRequest
            .withPhoneNumber(_cleansePhoneNumber())
            .withServiceProviderCode(beneficiary?.getBeneficiaryProviderCode() ?? "")
            .withMinorCreditAmount((this.amount ?? 0) * 100)
            .withMetaData(buildTransactionMetaData(describeEnum(_purchaseType)))
            .name = beneficiary?.getAccountName();
        break;
      case PurchaseType.DATA:
        dataTopUpRequest
            .withPhoneNumber(_cleansePhoneNumber())
            .withDataProviderItemCode(_dataPlan?.code ?? "")
            .withMetaData(buildTransactionMetaData(describeEnum(_purchaseType)))
            .withDataProviderName(beneficiary?.getBeneficiaryProviderName() ?? "")
            .withMinorCreditAmount((this.amount ?? 0) * 100)
            .name = beneficiary?.getAccountName();
        break;
    }

    requestBody
        .withAuthenticationType(AuthenticationMethod.PIN)
        .withDeviceId(_deviceManager.deviceId ?? "")
        .withSaveBeneficiary(saveBeneficiary ?? false)
        .withSourceAccountNumber(sourceAccount?.customerAccount?.accountNumber ?? "")
        .withSourceAccountProviderCode(sourceAccount?.accountProvider?.centralBankCode ?? "")
        .withPin(pin);


    switch(this.purchaseType){
      case PurchaseType.AIRTIME:
        return _delegate.makePurchase(requestBody.withAirtimeRequest(airtimeRequest));
      case PurchaseType.DATA:
        return _delegate.makePurchase(requestBody.withDataTopUpRequest(dataTopUpRequest));
    }
  }

  Stream<Uint8List> downloadReceipt(int batchId){
    return _delegate.downloadReceipt(customerId.toString(), batchId, purchaseType);
  }


  Stream<Resource<FileResult>> getFile(String fileUUID) {
    return _fileServiceDelegate.getFileByUUID(fileUUID, shouldFetchRemote: false);
  }

  Stream<Resource<AccountStatus>> fetchAccountStatus() {
    return this.accountServiceDelegate!.getAccountStatus(customerAccountId);
  }

}