import 'package:json_annotation/json_annotation.dart';

part 'short_term_loan_eligibility_criteria.g.dart';

@JsonSerializable()
class ShortTermLoanEligibilityCriteria {
  List<dynamic>? passedCriteria;
  List<dynamic>? failedCriteria;
  @JsonKey(name: "eligible")
  bool? isEligible;

  ShortTermLoanEligibilityCriteria({
    this.passedCriteria,
    this.failedCriteria,
    this.isEligible,
  });

  factory ShortTermLoanEligibilityCriteria.fromJson(Object? data) =>
    _$ShortTermLoanEligibilityCriteriaFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ShortTermLoanEligibilityCriteriaToJson(this);
}
