import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/login/model/data/authentication_method.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/core/models/transaction_meta_data.dart';

part 'bill_payment_request_body.g.dart';

@JsonSerializable(includeIfNull: false)
class BillPaymentRequestBody  {

  @JsonKey(name:"paymentType")
  PaymentType paymentType = PaymentType.ONE_TIME;

  @JsonKey(name:"sourceAccountProviderCode")
  String? sourceAccountProviderCode;

  @JsonKey(name:"sourceAccountNumber")
  String? sourceAccountNumber;

  @JsonKey(name:"currencyCode")
  String? currencyCode;

  @JsonKey(name:"request")
  Request? request;

  @JsonKey(name:"tracked")
  bool? tracked;

  @JsonKey(name:"saveBeneficiary")
  bool? saveBeneficiary;

  @JsonKey(name:"pin")
  String? pin;

  @JsonKey(name:"otp")
  String? otp;

  @JsonKey(name:"fingerprintKey")
  String? fingerprintKey;

  @JsonKey(name:"deviceId")
  String? deviceId;

  @JsonKey(name:"authenticationType")
  AuthenticationMethod? authenticationType;

  @JsonKey(name:"metaDataObj")
  TransactionMetaData? metaData;

  BillPaymentRequestBody() {
    paymentType = PaymentType.ONE_TIME;
  }

  factory BillPaymentRequestBody.fromJson(Object? data) => _$BillPaymentRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BillPaymentRequestBodyToJson(this);


  BillPaymentRequestBody withSourceAccountProviderCode(String sourceAccountProviderCode) {
    this.sourceAccountProviderCode = sourceAccountProviderCode;
    return this;
  }

  BillPaymentRequestBody withSourceAccountNumber(String sourceAccountNumber) {
    this.sourceAccountNumber = sourceAccountNumber;
    return this;
  }

  BillPaymentRequestBody withCurrencyCode(String currencyCode) {
    this.currencyCode = currencyCode;
    return this;
  }

  void setRequest(Request request) {
    this.request = request;
  }

  BillPaymentRequestBody withRequest(Request request) {
    this.request = request;
    return this;
  }


  BillPaymentRequestBody withTracked(bool tracked) {
    this.tracked = tracked;
    return this;
  }

  BillPaymentRequestBody withPin(String pin) {
    this.pin = pin;
    return this;
  }

  BillPaymentRequestBody withFingerprintKey(String fingerprintKey) {
    this.fingerprintKey = fingerprintKey;
    return this;
  }

  BillPaymentRequestBody withDeviceId(String deviceId) {
    this.deviceId = deviceId;
    return this;
  }

  BillPaymentRequestBody withAuthenticationType(AuthenticationMethod authenticationType) {
    this.authenticationType = authenticationType;
    return this;
  }

  BillPaymentRequestBody withSaveBeneficiary(bool saveBeneficiary) {
    this.saveBeneficiary = saveBeneficiary;
    return this;
  }

  BillPaymentRequestBody withMetaData(TransactionMetaData metaData) {
    this.metaData = metaData;
    return this;
  }

}

@JsonSerializable(includeIfNull: false)
class Request {

  @JsonKey(name:"minorCost")
  String? minorCost;

  @JsonKey(name:"customerId")
  String? customerId;

  @JsonKey(name:"billerProductCode")
  String? billerProductCode;

  @JsonKey(name:"customerValidationReference")
  String? customerValidationReference;

  @JsonKey(name:"additionalFieldsMap")
  Map<String, String>? additionalFieldsMap;

  @JsonKey(name:"metaDataObj")
  TransactionMetaData? metaData;

  Request();

  factory Request.fromJson(Object? data) => _$RequestFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$RequestToJson(this);

  void setAdditionalFieldsMap(Map<String, String> additionalFieldsMap) {
    this.additionalFieldsMap = additionalFieldsMap;
  }

  Request withMinorCost(String minorCost) {
    this.minorCost = minorCost;
    return this;
  }

  Request withCustomerId(String customerId) {
    this.customerId = customerId;
    return this;
  }

  Request withBillerProductCode(String billerProductCode) {
    this.billerProductCode = billerProductCode;
    return this;
  }

  Request withCustomerValidationReference(String customerValidationReference) {
    this.customerValidationReference = customerValidationReference;
    return this;
  }

  Request withAdditionalFieldsMap(Map<String, String> additionalFieldsMap) {
    this.additionalFieldsMap = additionalFieldsMap;
    return this;
  }

  Request withMetaData(TransactionMetaData metaData) {
    this.metaData = metaData;
    return this;
  }
}
