import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable()
class Card {
  @JsonKey(name:"id")
  final int? id;

  @JsonKey(name:"status")
  // final CardStatus? status;
//    @JsonKey(name:"createdOn") val createdOn: String? = null,
//    @JsonKey(name:"lastModifiedOn") val lastModifiedOn: String? = null,
  @JsonKey(name:"encryptedPan")
  final String? encryptedPan;

  @JsonKey(name:"maskedPan")
  final String maskedPan;

  @JsonKey(name:"hashedPan")
  final String? hashedPan;

  @JsonKey(name:"expiryDate")
  final String? expiryDate;

  @JsonKey(name:"branchCode")
  final String? branchCode;

  @JsonKey(name:"dateActivated")
  final String? dateActivated;

  @JsonKey(name:"dateIssued")
  final String? dateIssued;

  @JsonKey(name:"issuerReference")
  final String? issuerReference;

  @JsonKey(name:"nameOnCard")
  final String? nameOnCard;

  @JsonKey(name:"defaultAccountType")
  final String? defaultAccountType;

  @JsonKey(name:"cardProgram")
  final String? cardProgram;

  @JsonKey(name:"transactionChannelBlockStatus")
  final TransactionChannelBlockStatus? channelBlockStatus;

  @JsonKey(name:"cardProduct")
  final CardProduct? cardProduct;

  @JsonKey(name:"sequenceNumber")
  final String? sequenceNumber;

  @JsonKey(name:"cardAccountNumber")
  final String? cardAccountNumber;

  @JsonKey(name:"customerAccountCard")
  final CustomerAccountCard? customerAccountCard;

  @JsonKey(name:"cardRequestBatch")
  final String? cardRequestBatch;

  @JsonKey(name:"blocked")
  bool blocked = false;

  @JsonKey(name:"isActivated")
  bool isActivated = false;

  @JsonKey(name:"blockReason")
  final String? blockReason;

  @JsonKey(name:"issued")
  final bool? issued;

  Card(
      {this.id,
      // this.status,
      this.encryptedPan,
      required this.maskedPan,
      this.hashedPan,
      this.expiryDate,
      this.branchCode,
      this.dateActivated,
      this.dateIssued,
      this.issuerReference,
      this.nameOnCard,
      this.defaultAccountType,
      this.cardProgram,
      this.channelBlockStatus,
      this.cardProduct,
      this.sequenceNumber,
      this.cardAccountNumber,
      this.customerAccountCard,
      this.cardRequestBatch,
      this.blockReason,
      this.issued,
      this.isActivated = false,
      required this.blocked,
      });

  factory Card.fromJson(Object? data) => _$CardFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CardToJson(this);

}

enum CardStatus {
  ACTIVE, IN_ACTIVE
}

@JsonSerializable()
class CardProduct {
  @JsonKey(name:"id") int? id;
  @JsonKey(name:"status") String? status;
  @JsonKey(name:"createdOn") String? createdOn;
  @JsonKey(name:"lastModifiedOn") String? lastModifiedOn;
  @JsonKey(name:"name") String? name;
  @JsonKey(name:"code") String? code;

  CardProduct();

  factory CardProduct.fromJson(Object? data) => _$CardProductFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CardProductToJson(this);
}

@JsonSerializable()
class CustomerAccountCard {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "createdOn")
  String? createdOn;
  @JsonKey(name: "lastModifiedOn")
  String? lastModifiedOn;
  @JsonKey(name: "customerAccountNumber")
  String? customerAccountNumber;
  @JsonKey(name: "customerAccountType")
  String? customerAccountType;

  CustomerAccountCard();

  factory CustomerAccountCard.fromJson(Object? data) => _$CustomerAccountCardFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CustomerAccountCardToJson(this);
}

@JsonSerializable()
class TransactionChannelBlockStatus {
  @JsonKey(name:"pos")
  bool pos = false;
  @JsonKey(name:"web")
  bool web = false;
  @JsonKey(name:"atm")
  bool atm = false;

  TransactionChannelBlockStatus({this.web = false, this.pos = false, this.atm = false});

  factory TransactionChannelBlockStatus.fromJson(Object? data) => _$TransactionChannelBlockStatusFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransactionChannelBlockStatusToJson(this);

}