

import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/savings/model/data/flex_saving_interest_profile.dart';
import 'package:moniepoint_flutter/app/savings/model/data/flex_saving_scheme.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_withdrawal_count.dart';

import 'flex_saving_config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'flex_saving.g.dart';

const FLEX_SAVING_TABLE = "flex_savings";
@Entity(tableName: "$FLEX_SAVING_TABLE", primaryKeys: ['id'])
@JsonSerializable()
class FlexSaving {

  FlexSaving({
    required this.id,
    this.createdOn,
    this.customer,
    this.flexVersion,
    this.cbaAccountNuban,
    this.flexSavingScheme,
    this.flexSavingInterestProfile,
    this.flexSavingConfigId,
    this.configCreated,
    this.name
  });

  @JsonKey(name: "customerFlexSavingId")
  final int id;
  @JsonKey(name: "createdOn", fromJson: stringDateTime, toJson: millisToString)
  final int? createdOn;
  @ignore
  final Customer? customer;
  final String? flexVersion;
  final String? cbaAccountNuban;
  @TypeConverters([FlexSavingSchemeConverter])
  final FlexSavingScheme? flexSavingScheme;
  @TypeConverters([FlexSavingInterestProfileConverter])
  final FlexSavingInterestProfile? flexSavingInterestProfile;
  final bool? configCreated;
  final int? flexSavingConfigId;
  @ColumnInfo(name:"flexSavingName")
  final String? name;

  @ignore
  FlexWithdrawalCount? withdrawalCount;

  @ignore
  AccountBalance? accountBalance;

  factory FlexSaving.fromJson(Map<String, dynamic> json) => _$FlexSavingFromJson(json);

  Map<String, dynamic> toJson() => _$FlexSavingToJson(this);

  FlexSaving withWithdrawalCount(FlexWithdrawalCount? withdrawalCount) {
    this.withdrawalCount = withdrawalCount;
    return this;
  }
}
