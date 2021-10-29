import 'package:json_annotation/json_annotation.dart';

part 'short_term_loan_advert.g.dart';

@JsonSerializable()
class ShortTermLoanAdvert {
  String? name;
  String? description;
  int? minInterestRate;
  int? maxAmount;
  String? penaltyString;

  ShortTermLoanAdvert({
    this.name,
    this.description,
    this.minInterestRate,
    this.maxAmount,
    this.penaltyString,
  });

  factory ShortTermLoanAdvert.fromJson(Object? data) =>
      _$ShortTermLoanAdvertFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ShortTermLoanAdvertToJson(this);
}
