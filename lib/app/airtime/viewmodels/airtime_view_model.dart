import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/airtime/model/airtime_service_delegate.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_data_request.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_request_body.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_type.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/data_topup_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/authentication_method.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/airtime_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/core/device_manager.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AirtimeViewModel extends BaseViewModel with PaymentViewModel {
  late final AirtimeServiceDelegate _delegate;
  late final AirtimeBeneficiaryServiceDelegate _beneficiaryServiceDelegate;
  late final DeviceManager _deviceManager;

  PurchaseType _purchaseType = PurchaseType.AIRTIME;
  PurchaseType get purchaseType => _purchaseType;

  AirtimeServiceProviderItem? _dataPlan;
  AirtimeServiceProviderItem? get dataPlan => _dataPlan;

  AirtimeViewModel({AirtimeServiceDelegate? delegate,
    AirtimeBeneficiaryServiceDelegate? beneficiaryServiceDelegate,
    DeviceManager? deviceManager}) {
    this._delegate = delegate ?? GetIt.I<AirtimeServiceDelegate>();
    this._beneficiaryServiceDelegate = beneficiaryServiceDelegate ?? GetIt.I<AirtimeBeneficiaryServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
  }

  Stream<Resource<List<AirtimeBeneficiary>>> getFrequentBeneficiaries() {
    return _beneficiaryServiceDelegate.getFrequentBeneficiaries();
  }

  Stream<Resource<List<AirtimeServiceProviderItem>>> getServiceProviderItems(String billerId) {
    return _delegate.getServiceProviderItems(billerId);
  }

  void setPurchaseType(PurchaseType purchaseType) => this._purchaseType = purchaseType;
  void setServiceProviderItem(AirtimeServiceProviderItem? item) {
    this._dataPlan = item;
    checkValidity();
  }

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    this.checkValidity();
  }

  @override
  bool validityCheck() {
    if(this.purchaseType == PurchaseType.DATA) {
      if(this.dataPlan == null) return false;
      final isAmountFixed = this.dataPlan?.priceFixed == true;
      final dataPlanAmount =  this.dataPlan?.amount ?? 0;
      return (isAmountFixed) ? this.amount == (dataPlanAmount /100): this.amount != null && this.amount! > 0;
    }
    return this.amount != null && (this.amount ?? 0) > 0;
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
        .withSourceAccountNumber(accountNumber)
        .withSourceAccountProviderCode(accountProviderCode)
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

}