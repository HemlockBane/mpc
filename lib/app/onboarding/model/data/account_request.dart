import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/profile_request.dart';
import 'package:moniepoint_flutter/core/models/gender.dart';
import 'package:moniepoint_flutter/core/models/security_answer.dart';

part 'account_request.g.dart';

@JsonSerializable()
class AccountCreationRequestBody extends ProfileCreationRequestBody {
  @JsonKey(name: "bvn")
  String? bvn;

  @JsonKey(name: "dob")
  String? dateOfBirth;

  @JsonKey(name: "phoneNumber")
  String? phoneNumber;

  @JsonKey(name: "emailAddress")
  String? emailAddress;

  @JsonKey(name: "firstName")
  String? firstName;

  @JsonKey(name: "surname")
  String? surname;

  @JsonKey(name: "gender")
  Gender? gender;

  @JsonKey(name: "otherName")
  String? otherName;

  @JsonKey(name: "ussdPin")
  String? ussdPin;

  @JsonKey(name: "transactionPin")
  String? transactionPin;

  @JsonKey(name: "createUssd")
  bool createUssdPin = false;

  @JsonKey(name: "userImageUUID")
  String? selfieImageUUID;

  @JsonKey(name: "signatureUUID")
  String? signatureUUID;

  @JsonKey(name: "livelinessCheck")
  String? livelinessCheck;

  AccountCreationRequestBody():super();

  factory AccountCreationRequestBody.fromJson(Map<String, dynamic> data) => _$AccountCreationRequestBodyFromJson(data);
  Map<String, dynamic> toJson() => _$AccountCreationRequestBodyToJson(this);

  AccountCreationRequestBody withSelfieUUID(String selfieImage) {
    this.selfieImageUUID = selfieImage;
    return this;
  }

  AccountCreationRequestBody withSignatureUUID(String signature) {
    this.signatureUUID = signature;
    return this;
  }

  AccountCreationRequestBody withBVN(String bvn) {
    this.bvn = bvn;
    return this;
  }

  AccountCreationRequestBody withDateOfBirth(String dateOfBirth) {
    this.dateOfBirth = dateOfBirth;
    return this;
  }

  AccountCreationRequestBody withEmailAddress(String emailAddress) {
    this.emailAddress = emailAddress;
    return this;
  }

  AccountCreationRequestBody withPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    return this;
  }

  AccountCreationRequestBody withUSSDPin(String ussdPin) {
    this.ussdPin = ussdPin;
    return this;
  }

  AccountCreationRequestBody withCreateUSSDPin(bool create) {
    this.createUssdPin = create;
    return this;
  }

  AccountCreationRequestBody withFirstName(String firstName) {
    this.firstName = firstName;
    return this;
  }

  AccountCreationRequestBody withSurname(String surname) {
    this.surname = surname;
    return this;
  }

  AccountCreationRequestBody withOtherName(String otherName) {
    this.otherName = otherName;
    return this;
  }

  AccountCreationRequestBody withTransactionPin(String transactionPin) {
    this.transactionPin = transactionPin;
    return this;
  }

  AccountCreationRequestBody withGender(Gender gender) {
    this.gender = gender;
    return this;
  }
}