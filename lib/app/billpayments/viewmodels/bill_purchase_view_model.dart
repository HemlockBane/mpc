import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_payment_request_body.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/login/model/data/authentication_method.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/device_manager.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillPurchaseViewModel extends BaseViewModel with PaymentViewModel {

  late final BillServiceDelegate _delegate;
  late final BillBeneficiaryServiceDelegate _beneficiaryServiceDelegate;
  late final FileManagementServiceDelegate _fileServiceDelegate;
  late final DeviceManager _deviceManager;

  List<ListDataItem<String>> _amountPills = List.generate(4, (index) => ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));
  List<ListDataItem<String>> get amountPills => _amountPills;

  //<fieldKey, fieldError>
  StreamController<Tuple<String, String?>> _fieldErrorController = StreamController.broadcast();
  Stream<Tuple<String, String?>> get fieldErrorStream => _fieldErrorController.stream;

  Biller? _biller;
  Biller? get biller => _biller;

  BillerProduct? _billerProduct;
  BillerProduct? get billerProduct => _billerProduct;

  BillerCategory? _billerCategory;
  BillerCategory? get billerCategory => _billerCategory;

  String? validationReference;

  Map<String, String> _additionalFieldsMap = HashMap();
  Map<String, String?> _fieldErrorMap = HashMap();

  BillPurchaseViewModel({
    BillServiceDelegate? delegate,
    BillBeneficiaryServiceDelegate? beneficiaryServiceDelegate,
    FileManagementServiceDelegate? fileServiceDelegate,
    DeviceManager? deviceManager
  }) {
    this._delegate = delegate ?? GetIt.I<BillServiceDelegate>();
    this._beneficiaryServiceDelegate = beneficiaryServiceDelegate ?? GetIt.I<BillBeneficiaryServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
    this._fileServiceDelegate = fileServiceDelegate ?? GetIt.I<FileManagementServiceDelegate>();
  }

  Stream<Resource<List<BillerProduct>>> getBillerProducts() {
    return _delegate.getBillerProducts(_biller?.code ?? "");
  }

  Stream<Resource<List<BillBeneficiary>>> getFrequentBeneficiaries() {
    return _beneficiaryServiceDelegate.getFrequentBeneficiariesByBiller(5, _biller?.code ?? "");
  }

  void setBiller(Biller? biller) {
    this._biller = biller;
  }

  void setBillerCategory(BillerCategory? category) {
    this._billerCategory = category;
  }

  void resetAdditionalFields() {
    _amountPills = List.generate(4, (index) => ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));
    this._additionalFieldsMap.clear();
    this._fieldErrorMap.clear();
    _billerProduct?.additionalFieldsMap?.forEach((key, value) {
      if(value.required && key != "amount") _fieldErrorMap[key] = "";
    });
    this.setSourceAccount(null);
    setAmount((_billerProduct?.amount ?? 0.00) / 100);
  }

  void setBillerProduct(BillerProduct? billerProduct) {
    this._billerProduct = billerProduct;
   this.resetAdditionalFields();
    setAmount((_billerProduct?.amount ?? 0.00) / 100);
  }

  void setValidationReference(String validationReference) {
    this.validationReference = validationReference;
  }

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    this.checkValidity();
  }

  @override
  void setSourceAccount(UserAccount? userAccount) {
    super.setSourceAccount(userAccount);
    checkValidity();
  }

  void setAdditionalFieldData(String key, String value) {
    _additionalFieldsMap[key] = value;
    validateAdditionalFieldsForKey(key);
  }

  String? setDefaultAdditionalFieldValue(String key) {
    if (key == "emailAddress" && _additionalFieldsMap[key] == null) {
      setAdditionalFieldData(key, customer?.email ?? "");
      return customer?.email;
    }
    if (key == "phoneNumber" && _additionalFieldsMap[key] == null) {
      //TODO country code shouldn't really be hardcoded if we are to support other countries
      if((customer?.mobileNo?.length ?? 0) > 4 && customer?.mobileNo?.substring(0, 3) == "234") {
        final mobileNumber = customer?.mobileNo?.replaceRange(0, 3, "0");
        setAdditionalFieldData(key, mobileNumber ?? "");
        return mobileNumber;
      }
      setAdditionalFieldData(key, customer?.mobileNo ?? "");
      return customer?.mobileNo;
    }
    return null;
  }

  String? getFieldErrorForKey(String key) {
    return _fieldErrorMap[key];
  }

  bool validateAdditionalFieldsForKey(String key) {
    if(_billerProduct == null) return false;

    final inputFieldForKey = _billerProduct?.additionalFieldsMap?[key];

    if(inputFieldForKey == null) return false;

    //let's check that we currently have the value set
    final keyExist = _additionalFieldsMap.containsKey(key);
    final isFieldRequired = inputFieldForKey.required;
    final keyValue = _additionalFieldsMap[key];

    if(isFieldRequired) {
      if(!keyExist || (keyValue == null || keyValue.isEmpty)) {
        _fieldErrorMap[key] = "The ${inputFieldForKey.fieldLabel?.toLowerCase()} field is required.";
        _fieldErrorController.sink.addError(Tuple(key, _fieldErrorMap[key]));
        checkValidity();
        return false;
      }
    }

    final minimumLengthRequired = inputFieldForKey.minimumLength;
    if(isFieldRequired && keyExist && minimumLengthRequired != null && (keyValue == null || keyValue.length < minimumLengthRequired)) {
      _fieldErrorMap[key] = "${inputFieldForKey.fieldLabel} cannot be less than ${inputFieldForKey.minimumLength?.toInt()} characters";
      _fieldErrorController.sink.addError(Tuple(key, _fieldErrorMap[key]));
      checkValidity();
      return false;
    }

    _fieldErrorMap[key] = null;
    _fieldErrorController.addError(Tuple(key, null));
    checkValidity();
    return true;
  }

  @override
  bool validityCheck() {
    if(_billerProduct == null || sourceAccount == null) return false;
    final isAmountFixed = this._billerProduct?.priceFixed == true;
    final productAmount = this._billerProduct?.amount ?? 0;
    final minAmount = billerProduct?.minimumAmount ?? 0;
    final maxAmount = billerProduct?.maximumAmount ?? 9007199254740991;

    //validate amount
    final isAmountValid = (isAmountFixed)
        ? this.amount == (productAmount / 100)
        : this.amount != null && (this.amount! >= minAmount && this.amount! <= maxAmount);

    final isFormValid = _fieldErrorMap.values.every((element) => element == null);
    return isAmountValid && isFormValid;
  }

  @override
  void dispose() {
    _fieldErrorController.close();
    super.dispose();
  }

  Stream<Resource<TransactionStatus>> makePayment() {
    final request = Request()
        .withAdditionalFieldsMap(_additionalFieldsMap)
        .withCustomerValidationReference(validationReference ?? "")
        .withBillerProductCode(billerProduct?.paymentCode ?? "")
        .withCustomerId(beneficiary?.getBeneficiaryDigits() ?? "")
        .withLocation(buildLocationData())
        .withMinorCost(((amount ?? 0) * 100).toInt().toString());

    final requestBody = BillPaymentRequestBody()
      .withAuthenticationType(AuthenticationMethod.PIN)
      .withSaveBeneficiary(saveBeneficiary ?? false)
      .withPin(pin)
      .withSourceAccountNumber(sourceAccount?.customerAccount?.accountNumber ?? "")
      .withSourceAccountProviderCode(sourceAccount?.accountProvider?.centralBankCode ?? "")
      .withRequest(request)
      .withDeviceId(_deviceManager.deviceId ?? "");

    return _delegate.makePurchase(requestBody);
  }

  Stream<Uint8List> downloadReceipt(int batchId){
    return _delegate.downloadReceipt(customerId.toString(), batchId);
  }

  Stream<Resource<FileResult>> getFile(String fileUUID) {
    return _fileServiceDelegate.getFileByUUID(fileUUID);
  }

}