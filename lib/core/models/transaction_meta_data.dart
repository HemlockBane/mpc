
import 'package:json_annotation/json_annotation.dart';

part 'transaction_meta_data.g.dart';


@JsonSerializable(includeIfNull: false)
class TransactionMetaData {
  TransactionMetaData({
    this.location,
    this.recipient,
    this.transactionType,
  });

  Location? location;
  Recipient? recipient;
  String? transactionType;

  factory TransactionMetaData.fromJson(Object? data) => _$TransactionMetaDataFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransactionMetaDataToJson(this);

}

@JsonSerializable(includeIfNull: false)
class Location {
  Location({
    this.latitude,
    this.longitude,
  });

  String? latitude;
  String? longitude;

  factory Location.fromJson(Object? data) => _$LocationFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

}

@JsonSerializable(includeIfNull: false)
class Recipient {
  Recipient({
    this.name,
    this.accountNumber,
    this.bankName,
    this.bankCode,
  });

  String? name;
  String? accountNumber;
  String? bankName;
  String? bankCode;

  factory Recipient.fromJson(Object? data) => _$RecipientFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$RecipientToJson(this);

}
