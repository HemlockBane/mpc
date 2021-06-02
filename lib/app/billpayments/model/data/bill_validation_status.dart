import 'package:json_annotation/json_annotation.dart';


part 'bill_validation_status.g.dart';

@JsonSerializable()
class BillValidationStatus {

  @JsonKey(name:"customerId")
  final String? customerId;

  @JsonKey(name:"paymentCode")
  final String? paymentCode;

  @JsonKey(name:"fullName")
  final String? fullName;

  @JsonKey(name:"responseDescription")
  final String? responseDescription;

  @JsonKey(name:"validationReference")
  final String? validationReference;

  @JsonKey(name:"validationData")
  final ValidationData? validationData;

  @JsonKey(name:"status")
  final String? status;

  @JsonKey(name:"message")
  final String? message;

  BillValidationStatus(
      {this.customerId,
      this.paymentCode,
      this.fullName,
      this.responseDescription,
      this.validationReference,
      this.validationData,
      this.status,
      this.message});

  factory BillValidationStatus.fromJson(Object? data) => _$BillValidationStatusFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BillValidationStatusToJson(this);

}

@JsonSerializable()
class ValidationData  {
  @JsonKey(name:"customer_name")
  final String? customerName;

  ValidationData(this.customerName);

  factory ValidationData.fromJson(Object? data) => _$ValidationDataFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ValidationDataToJson(this);

}
