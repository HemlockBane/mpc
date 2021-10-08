import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';
import 'scheme_code.dart';

part 'customer_account.g.dart';

enum BlockedBy {
  BACKOFFICE,
  CUSTOMER,
  SYSTEM,
  AGENT
}

@JsonSerializable()
class CustomerAccount {
  int? id;
  Customer? customer;
  String? cbaCustomerId;
  int? bankBranchId;
  String? accountName;
  String? currencyCode;
  String? accountNumber;
  String? phoneNumber;
  String? email;
  String? address;
  // List<int>? openingDate;
  String? alternateAccountNumber;
  String? accountType;
  String? bvn;
  double? accountBalance;
  SchemeCode? schemeCode;
  bool? validated;
  String? relationshipManagerNodeGuid;
  String? relationshipManagerUserId;
  bool? active;
  List<String>? unsupportedFeatures;
  bool? multipleDebit;
  bool? blocked;
  String? blockReason;
  BlockedBy? blockedBy;
  String? blockedTime;
  String? referralCode;

  CustomerAccount(
      { this.id,
        this.customer,
        this.cbaCustomerId,
        this.bankBranchId,
        this.accountName,
        this.currencyCode,
        this.accountNumber,
        this.phoneNumber,
        this.email,
        this.address,
        // this.openingDate,
        this.alternateAccountNumber,
        this.accountType,
        this.bvn,
        this.accountBalance,
        this.schemeCode,
        this.validated = false,
        this.relationshipManagerNodeGuid,
        this.relationshipManagerUserId,
        this.active,
        this.unsupportedFeatures,
        this.multipleDebit,
        this.blocked,
        this.blockedBy,
        this.blockReason,
        this.referralCode
      });


  factory CustomerAccount.fromJson(Object? data) => _$CustomerAccountFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CustomerAccountToJson(this);


}