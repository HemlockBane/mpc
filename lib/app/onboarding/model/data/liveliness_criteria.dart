import 'package:json_annotation/json_annotation.dart';

part 'liveliness_criteria.g.dart';

@JsonSerializable()
class LivelinessChecks {
  final List<Liveliness>? challenges;
  final List<Liveliness>? generalProblems;
  final Liveliness? profilePictureCriteria;

  LivelinessChecks({this.challenges, this.generalProblems, this.profilePictureCriteria});

  factory LivelinessChecks.fromJson(Map<String, dynamic> data) => _$LivelinessChecksFromJson(data);
  Map<String, dynamic> toJson() => _$LivelinessChecksToJson(this);
}

@JsonSerializable()
class Liveliness {
  final String? name;
  final String? description;
  final Criteria criteria;

  Liveliness({this.name, this.description, required this.criteria});

  factory Liveliness.fromJson(Map<String, dynamic> data) => _$LivelinessFromJson(data);
  Map<String, dynamic> toJson() => _$LivelinessToJson(this);
}

@JsonSerializable()
class Criteria {
  final String name;
  final bool? value;
  final PoseValue? pitch;
  final PoseValue? roll;
  final PoseValue? yaw;
  final PoseValue? confidence;
  final PoseValue? sharpness;
  final PoseValue? brightness;

  Criteria({required this.name,
    this.value,
    this.pitch,
    this.roll,
    this.yaw,
    this.confidence,
    this.sharpness,
    this.brightness});

  factory Criteria.fromJson(Map<String, dynamic> data) => _$CriteriaFromJson(data);
  Map<String, dynamic> toJson() => _$CriteriaToJson(this);
}

@JsonSerializable()
class PoseValue {
  final double? positive;
  final double? negative;

  PoseValue({
    this.positive,
    this.negative,
});

  factory PoseValue.fromJson(Map<String, dynamic> data) => _$PoseValueFromJson(data);
  Map<String, dynamic> toJson() => _$PoseValueToJson(this);
}
