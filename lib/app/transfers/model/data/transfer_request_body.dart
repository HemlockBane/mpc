import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/login/model/data/authentication_method.dart';

part 'transfer_request_body.g.dart';

enum PaymentType {
  ONE_TIME
}

@JsonSerializable()
class TransferRequestBody {
  AuthenticationMethod? authenticationType;
  String? pin;
  bool? beneficiary;
  String? deviceId;
  int? minorAmount;
  int? minorFeeAmount;
  int? minorVatAmount;
  String? name;
  String? narration;
  PaymentType paymentType;
  String? sinkAccountNumber;
  String? sinkAccountProviderCode;
  String? sinkAccountProviderName;
  String? sourceAccountNumber;
  String? sourceAccountProviderCode;
  String? userCode;
  String? validatedAccountName;
  String? metaData;

  TransferRequestBody({
    this.authenticationType = AuthenticationMethod.PIN,
    this.pin,
    this.beneficiary,
    this.deviceId,
    this.minorAmount,
    this.minorFeeAmount,
    this.minorVatAmount,
    this.name,
    this.narration,
    this.paymentType = PaymentType.ONE_TIME,
    this.sinkAccountNumber,
    this.sinkAccountProviderCode,
    this.sinkAccountProviderName,
    this.sourceAccountNumber,
    this.sourceAccountProviderCode,
    this.userCode,
    this.validatedAccountName,
    this.metaData
  });

  factory TransferRequestBody.fromJson(Object? data) => _$TransferRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransferRequestBodyToJson(this);

}