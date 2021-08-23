import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/login/model/data/login_prompt.dart';
import 'dart:developer' as developer;
import 'dart:convert';


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
   @JsonKey(name: "loginCommandPrompts")
  List<LoginPrompt>? loginPrompts;


  User();

  User withAccessToken(String? token) {
    this.accessToken = token;
    return this;
  }

  // User.init({this.accessToken,
  //   this.tokenType,
  //   this.expiresIn,
  //   this.scope,
  //   this.lastLogin,
  //   this.lastName,
  //   this.securityFlags,
  //   this.fullName,
  //   this.firstName,
  //   this.phoneNumber,
  //   this.isValidated,
  //   this.response,
  //   this.middleName,
  //   this.customers,
  //   this.email,
  //   this.username});

  factory User.fromJson(Object? data) =>
      _$UserFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
