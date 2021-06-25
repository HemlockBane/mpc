import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/transfer_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/app/transfers/model/transfer_service_delegate.dart';
import 'package:moniepoint_flutter/core/device_manager.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

enum TransferTransactionType {
INTRA_BANK_TRANSFER, INTER_BANK_TRANSFER
}

///@author Paul Okeke
class TransferViewModel extends BaseViewModel with PaymentViewModel {
  late final TransferServiceDelegate _delegate;
  late final TransferBeneficiaryServiceDelegate _beneficiaryServiceDelegate;
  late final DeviceManager _deviceManager;

  String _narration = "";

  FeeVatConfig? _feeVatConfig;
  int? _minorFee = 0;
  int? _minorVat = 0;

  TransferViewModel({
    TransferServiceDelegate? delegate,
    TransferBeneficiaryServiceDelegate? beneficiaryServiceDelegate,
    DeviceManager? deviceManager
  }) {
    this._delegate = delegate ?? GetIt.I<TransferServiceDelegate>();
    this._beneficiaryServiceDelegate = beneficiaryServiceDelegate ?? GetIt.I<TransferBeneficiaryServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
    //Load all feeVatConfig at once
    _delegate.getAllFeeAndVatConfigByType().listen((event) {
      if((event is Success || event is Loading) && event.data != null){
        _feeVatConfig = event.data;
      }
    });
  }

  Stream<Resource<List<TransferBeneficiary>>> getFrequentBeneficiaries() {
    return _beneficiaryServiceDelegate.getFrequentBeneficiaries();
  }

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    print("Setting amount $amount");
    this.checkValidity();
  }

  void setNarration(String narration) {
    this._narration = narration;
    validityCheck();
  }

  @override
  bool validityCheck() {
    return (this.amount ?? 0.00) > 0;
  }

  bool isIntra() {
    return beneficiary!.getBeneficiaryProviderCode() == "950515";
  }

  String getTransactionType() {
    if(isIntra()) return describeEnum(TransferTransactionType.INTRA_BANK_TRANSFER);
    else return describeEnum(TransferTransactionType.INTER_BANK_TRANSFER);
  }

  double getTransferFee() {
    if (_feeVatConfig == null || isIntra()) return 0.0;

    BoundedCharges? boundedCharge;

    final minorAmount = (this.amount ?? 0) * 100;

    _feeVatConfig?.boundedCharges?.forEach((element) {
      if (minorAmount >= element.lowerLimitMinor!) boundedCharge = element;
    });

    if (boundedCharge == null) return 0.0;

    switch(_feeVatConfig!.chargeType) {
      case "BOUNDED": {
          _minorFee = boundedCharge?.feeMinor ?? 0;
          _minorVat = boundedCharge?.vatMinor ?? 0;
        return (_minorFee! + _minorVat! + 0.0) / 100;
      }
      case "PERCENTAGE" :{
          return 0.0;
      }
      case "FIXED": {
       _minorFee = (_feeVatConfig?.minorFee ?? 0).toInt();
       _minorVat = (_feeVatConfig?.minorVat ?? 0).toInt();
        return _minorFee! + _minorVat! + 0.0 / 100;
      }
    }
    return 0;
  }

  Stream<Resource<TransactionStatus>> makeTransfer() {
    final mBeneficiary = beneficiary;
    if(mBeneficiary == null) return Stream.value(Resource.error(err: ServiceError(message: "Invalid State")));
    final request = TransferRequestBody()
        ..beneficiary = saveBeneficiary
        ..sinkAccountProviderName = mBeneficiary.getBeneficiaryProviderName()
        ..sinkAccountNumber = mBeneficiary.getBeneficiaryDigits()
        ..sinkAccountProviderCode = mBeneficiary.getBeneficiaryProviderCode()
        ..sourceAccountNumber = accountNumber
        ..sourceAccountProviderCode = accountProviderCode
        ..deviceId = _deviceManager.deviceId
        ..validatedAccountName = mBeneficiary.getAccountName()
        ..minorAmount = (amount! * 100).toInt()
        ..pin = pin
        ..narration = _narration
        ..minorVatAmount = _minorVat
        ..metaData = buildTransactionMetaData(getTransactionType())
        ..minorFeeAmount = _minorFee;

    return _delegate.doTransfer(request);
  }

  Stream<Uint8List> downloadReceipt(int batchId){
    return _delegate.downloadReceipt(customerId.toString(), batchId);
  }

  @override
  void dispose() {
    super.dispose();
  }
}