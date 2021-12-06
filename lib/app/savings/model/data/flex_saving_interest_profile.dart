import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flex_saving_interest_profile.g.dart';


@JsonSerializable()
class FlexSavingInterestProfile {

  FlexSavingInterestProfile({
    required this.id,
    this.interestProfileCode,
    this.interestRate,
    this.isDefault
  });

  final int? id;
  final String? interestProfileCode;
  final double? interestRate;
  @JsonKey(name: "default")
  final bool? isDefault;

  factory FlexSavingInterestProfile.fromJson(Map<String, dynamic> json) => _$FlexSavingInterestProfileFromJson(json);
  Map<String, dynamic> toJson() => _$FlexSavingInterestProfileToJson(this);

}
