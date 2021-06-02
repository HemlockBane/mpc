import 'dart:async';
import 'dart:collection';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_payment_request_body.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/app/login/model/data/authentication_method.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillPurchaseViewModel extends BaseViewModel with PaymentViewModel {

  late final BillServiceDelegate _delegate;
  late final BillBeneficiaryServiceDelegate _beneficiaryServiceDelegate;

  //<fieldKey, fieldError>
  StreamController<Tuple<String, String?>> _fieldErrorController = StreamController.broadcast();
  Stream<Tuple<String, String?>> get fieldErrorStream => _fieldErrorController.stream;

  Biller? _biller;
  Biller? get biller => _biller;

  BillerProduct? _billerProduct;
  BillerProduct? get billerProduct => _billerProduct;

  String? validationReference;

  Map<String, String> _additionalFieldsMap = HashMap();
  Map<String, String?> _fieldErrorMap = HashMap();

  BillPurchaseViewModel({BillServiceDelegate? delegate,  BillBeneficiaryServiceDelegate? beneficiaryServiceDelegate}) {
    this._delegate = delegate ?? GetIt.I<BillServiceDelegate>();
    this._beneficiaryServiceDelegate = beneficiaryServiceDelegate ?? GetIt.I<BillBeneficiaryServiceDelegate>();
  }

  Stream<Resource<List<BillerProduct>>> getBillerProducts() {
    return _delegate.getBillerProducts(_biller?.code ?? "");
  }

  Stream<Resource<List<BillBeneficiary>>> getFrequentBeneficiaries() {
    print("Fetching fetching Beneficiaries for ${ _biller?.code}");
    return _beneficiaryServiceDelegate.getFrequentBeneficiariesByBiller(5, _biller?.code ?? "");
  }

  void setBiller(Biller? biller) {
    this._biller = biller;
  }

  void setBillerProduct(BillerProduct? billerProduct) {
    this._billerProduct = billerProduct;
    this._additionalFieldsMap.clear();
    this._fieldErrorMap.clear();
    _billerProduct?.additionalFieldsMap?.forEach((key, value) {
      if(value.required) _fieldErrorMap[key] = "";
    });
  }

  void setValidationReference(String validationReference) {
    this.validationReference = validationReference;
  }

  void setAdditionalFieldData(String key, String value) {
    _additionalFieldsMap[key] = value;
    validateAdditionalFieldsForKey(key);
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
      _fieldErrorController.sink
          .addError(Tuple(key, _fieldErrorMap[key]));
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
    if(_billerProduct == null) return false;
    final isAmountFixed = this._billerProduct?.priceFixed == true;
    final productAmount = this._billerProduct?.amount ?? 0;
    final isAmountValid = (isAmountFixed) ? this.amount == (productAmount /100): this.amount != null && this.amount! > 0;
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
        .withMinorCost(((amount ?? 0) * 100).toString());

    final requestBody = BillPaymentRequestBody()
      .withAuthenticationType(AuthenticationMethod.PIN)
      .withSaveBeneficiary(saveBeneficiary ?? false)
      .withPin(pin)
      .withSourceAccountNumber(accountNumber)
      .withSourceAccountProviderCode(accountProviderCode)
      .withRequest(request)
      .withDeviceId("deviceId");

    return _delegate.makePurchase(requestBody);
  }

}