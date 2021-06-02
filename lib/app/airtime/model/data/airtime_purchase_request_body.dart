import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/login/model/data/authentication_method.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';

import 'airtime_data_request.dart';
import 'data_topup_request.dart';

part 'airtime_purchase_request_body.g.dart';

@JsonSerializable(includeIfNull: false)
class AirtimePurchaseRequestBody {

  @JsonKey(name:"paymentType")
  PaymentType paymentType = PaymentType.ONE_TIME;
  
  @JsonKey(name:"sourceAccountProviderCode")
  String? sourceAccountProviderCode;
  
  @JsonKey(name:"sourceAccountNumber")
  String? sourceAccountNumber;
  
  @JsonKey(name:"tracked")
  bool? tracked;
  
  @JsonKey(name:"saveBeneficiary")
  bool? saveBeneficiary;
  
  @JsonKey(name:"airtimeRequest")
  AirtimeDataRequest? airtimeRequest;

  @JsonKey(name:"dataTopUpRequest")
  DataTopUpRequest? dataTopUpRequest;

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

  @JsonKey(name:"userCode")
  String? userCode;

  AirtimePurchaseRequestBody();

  factory AirtimePurchaseRequestBody.fromJson(Object? data) => _$AirtimePurchaseRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AirtimePurchaseRequestBodyToJson(this);

  AirtimePurchaseRequestBody withSourceAccountProviderCode(String sourceAccountProviderCode) {
    this.sourceAccountProviderCode = sourceAccountProviderCode;
    return this;
  }

  AirtimePurchaseRequestBody withSourceAccountNumber(String sourceAccountNumber) {
    this.sourceAccountNumber = sourceAccountNumber;
    return this;
  }

  AirtimePurchaseRequestBody withTracked(bool tracked) {
    this.tracked = tracked;
    return this;
  }

  AirtimePurchaseRequestBody withSaveBeneficiary(bool saveBeneficiary) {
    this.saveBeneficiary = saveBeneficiary;
    return this;
  }
  
  AirtimePurchaseRequestBody withAirtimeRequest(AirtimeDataRequest request) {
    this.airtimeRequest = request;
    return this;
  }

  AirtimePurchaseRequestBody withDataTopUpRequest(DataTopUpRequest request){
    this.dataTopUpRequest = request;
    return this;
  }

  AirtimePurchaseRequestBody withPin(String pin) {
    this.pin = pin;
    return this;
  }

  AirtimePurchaseRequestBody withFingerprintKey(String fingerprintKey) {
    this.fingerprintKey = fingerprintKey;
    return this;
  }

  AirtimePurchaseRequestBody withDeviceId(String deviceId) {
    this.deviceId = deviceId;
    return this;
  }

  AirtimePurchaseRequestBody withAuthenticationType(AuthenticationMethod authenticationType) {
    this.authenticationType = authenticationType;
    return this;
  }

}
