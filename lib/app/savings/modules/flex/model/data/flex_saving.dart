

import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/savings/model/data/flex_saving_scheme.dart';

import 'flex_saving_config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'flex_saving.g.dart';

@Entity(tableName: "flex_savings", primaryKeys: ['id'])
@JsonSerializable()
class FlexSaving {
  FlexSaving({
    required this.id,
    this.createdOn,
    this.customer,
    this.flexVersion,
    this.cbaAccountNuban,
    this.flexSavingScheme,
    this.flexSavingConfigId,
    this.configCreated
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
  final bool? configCreated;
  final int? flexSavingConfigId;

  factory FlexSaving.fromJson(Map<String, dynamic> json) => _$FlexSavingFromJson(json);

  Map<String, dynamic> toJson() => _$FlexSavingToJson(this);
}
