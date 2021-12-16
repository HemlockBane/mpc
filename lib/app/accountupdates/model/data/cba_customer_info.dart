import 'package:json_annotation/json_annotation.dart';

part 'cba_customer_info.g.dart';

@JsonSerializable()
class CBACustomerInfo {

  CBACustomerInfo(
      {this.title,
      this.firstName,
      this.middleName,
      this.lastName,
      this.gender,
      this.dateOfBirth,
      this.emailAddress,
      this.phoneNumber,
      this.bankVerificationNumber,
      this.countryCode,
      this.residentialAddress,
      this.mailingAddress,
      this.nextOfKin,
      this.id,
      this.code,
      this.status,
      this.passportRef,
      this.signatureRef,
      this.location,
      this.nationality,
      this.localGovernmentOfOrigin,
      this.religion,
      this.maritalStatus,
      this.motherMaidenName,
      this.taxIdentificationNumber,
      this.employmentStatus,
      this.identificationInfo,
      this.spousalInfo,
      this.employmentInfo,
      this.stateOfOrigin});

  final String? title;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final String? dateOfBirth;
  final String? emailAddress;
  final String? phoneNumber;
  final String? bankVerificationNumber;
  final String? countryCode;
  final Map<String, dynamic>? residentialAddress;
  final Map<String, dynamic>? mailingAddress;
  final Map<String, dynamic>? nextOfKin;
  final int? id;
  final String? code;
  final String? status;
  final String? passportRef;
  final String? signatureRef;
  final String? location;
  final String? nationality;
  final String? localGovernmentOfOrigin;
  final String? religion;
  final String? maritalStatus;
  final String? motherMaidenName;
  final String? taxIdentificationNumber;
  final String? employmentStatus;
  final Map<String, dynamic>? identificationInfo;
  final Map<String, dynamic>? spousalInfo;
  final Map<String, dynamic>? employmentInfo;
  final String? stateOfOrigin;

  factory CBACustomerInfo.fromJson(Object? data) => _$CBACustomerInfoFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CBACustomerInfoToJson(this);

}
