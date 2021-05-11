import 'package:json_annotation/json_annotation.dart';

import 'customer_account.dart';

part 'customer_account_user.g.dart';

@JsonSerializable()
class CustomerAccountUsers {
  int id;
  CustomerAccount? customerAccount;
  List<String>? permittedFeatures;
  bool? featureOverride;
  String? role;
  String? authenticationType;
  List<String>? authorities;
  List<String>? featureGroups;

  CustomerAccountUsers({
    required this.id,
    this.customerAccount,
    this.permittedFeatures,
    this.featureOverride,
    this.role,
    this.authenticationType,
    this.authorities = const [],
    this.featureGroups = const [],
  });

  factory CustomerAccountUsers.fromJson(Object? data) => _$CustomerAccountUsersFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CustomerAccountUsersToJson(this);

}
