import 'package:json_annotation/json_annotation.dart';

part 'custom_flags.g.dart';

@JsonSerializable()
class CustomFlags {
  final bool? verifiedAddress;
  final bool? identification;
  final bool? nextOfKin;
  final bool? address;
  final bool? verifiedIdentification;
  bool? signature;

  CustomFlags({this.verifiedAddress,
    this.identification,
    this.nextOfKin,
    this.address,
    this.verifiedIdentification,
    this.signature});

  factory CustomFlags.fromJson(Object? data) => _$CustomFlagsFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CustomFlagsToJson(this);

}