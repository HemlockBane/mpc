import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'airtime_service_provider_item.g.dart';

@Entity(tableName: "service_provider_items")
@JsonSerializable()
class AirtimeServiceProviderItem {

  @PrimaryKey()
  @JsonKey(name:"id")
  final int id;

  @JsonKey(name:"active")
  final bool? active;

  @JsonKey(name:"amount")
  final int? amount;

  @JsonKey(name:"code")
  final String? code;

  @JsonKey(name:"currencySymbol")
  final String? currencySymbol;

  @JsonKey(name:"fee")
  final double? fee;

  @JsonKey(name:"name")
  final String? name;

  @JsonKey(name:"paymentCode")
  final String? paymentCode;

  @JsonKey(name:"priceFixed")
  final bool? priceFixed;

  //We'll set this our-self
  @JsonKey(name:"billerId")
  String? billerId;

  AirtimeServiceProviderItem({
    required this.id,
    this.active,
    this.amount,
    this.code,
    this.currencySymbol,
    this.fee,
    this.name,
    this.paymentCode,
    this.priceFixed,
    this.billerId
  });

  factory AirtimeServiceProviderItem.fromJson(Object? data) => _$AirtimeServiceProviderItemFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AirtimeServiceProviderItemToJson(this);

}