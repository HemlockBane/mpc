import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_transaction_request.g.dart';

@JsonSerializable()
class CardTransactionRequest {
  @JsonKey(name:"cardId")
  int? cardId;
  @JsonKey(name:"transactionChannel", includeIfNull: false)
  TransactionChannel? transactionChannel;
  @JsonKey(name:"description", includeIfNull: false)
  String? description;
  @JsonKey(name:"transactionPin")
  String? transactionPin;
  @JsonKey(name:"pin")
  String? newPin;
  @JsonKey(name:"oldPin")
  String? oldPin;
  @JsonKey(name:"cvv")
  String? cvv;
  @JsonKey(name:"expiry", includeIfNull: false)
  String? expiry;
  @JsonKey(name:"customerAccountNumber")
  String? cardAccountNumber;

  CardTransactionRequest();

  factory CardTransactionRequest.fromJson(Object? data) => _$CardTransactionRequestFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CardTransactionRequestToJson(this);

}
