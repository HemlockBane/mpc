import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/address_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/customer_detail_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/customer_identification_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/next_of_kin_info.dart';

part 'account_update.g.dart';

@JsonSerializable()
class AccountUpdate {
  @JsonKey(name: "customerDetailInfo", includeIfNull: false)
  CustomerDetailInfo? customerDetailInfo;
  @JsonKey(name: "nextOfKinInfo", includeIfNull: false)
  NextOfKinInfo? nextOfKinInfo;
  @JsonKey(name: "mailingAddressInfo", includeIfNull: false)
  AddressInfo? mailingAddressInfo;
  @JsonKey(name: "customerIdentificationInfo", includeIfNull: false)
  CustomerIdentificationInfo? identificationInfo;

  AccountUpdate({
    this.customerDetailInfo,
    this.nextOfKinInfo,
    this.mailingAddressInfo,
    this.identificationInfo
  });

  factory AccountUpdate.fromJson(Object? data) => _$AccountUpdateFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccountUpdateToJson(this);


}