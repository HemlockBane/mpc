
import 'package:json_annotation/json_annotation.dart';

part 'card_request_balance_response.g.dart';

@JsonSerializable()
class CardRequestBalanceResponse {


  @JsonKey(name: "availableBalance")
  String? availableBalance;

  @JsonKey(name: "cardAmount")
  String? cardAmount;

  @JsonKey(name: "sufficient")
  bool? sufficient;

  CardRequestBalanceResponse();

  factory CardRequestBalanceResponse.fromJson(Object? data) => _$CardRequestBalanceResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CardRequestBalanceResponseToJson(this);

}