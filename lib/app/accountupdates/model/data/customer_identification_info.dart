import 'package:json_annotation/json_annotation.dart';

part 'customer_identification_info.g.dart';

@JsonSerializable()
class CustomerIdentificationInfo {
  String? identificationType;
  String? registrationNumber;
  String? identityIssueDate;
  String? identityExpiryDate;
  String? scannedImageRef;
  String? uploadedFileName;//internal use only

  CustomerIdentificationInfo({
    this.identificationType,
    this.registrationNumber,
    this.identityIssueDate,
    this.identityExpiryDate,
    this.scannedImageRef
  });

  factory CustomerIdentificationInfo.fromJson(Object? data) => _$CustomerIdentificationInfoFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CustomerIdentificationInfoToJson(this);

}