import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/customer/customer_account.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification_response_body.dart';


import 'security_flag.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "access_token")
  String? accessToken;
  @JsonKey(name: "token_type")
  String? tokenType;
  int? expiresIn;
  String? scope;
  int? lastLogin;
  String? lastName;
  bool? registerDevice;
  SecurityFlags? securityFlags;
  String? fullName;
  String? firstName;
  String? phoneNumber;
  bool? isValidated;
  String? response;
  String? middleName;
  List<Customer>? customers;
  String? email;
  String? username;

  User();

  User withAccessToken(String? token) {
    this.accessToken = token;
    return this;
  }

  List<CustomerAccount> getCustomerAccounts() {
    return this.customers?.firstOrNull?.customerAccountUsers
        ?.map((e) => e.customerAccount!).toList() ?? [];
  }

  factory User.fromJson(Object? data) =>
      _$UserFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
