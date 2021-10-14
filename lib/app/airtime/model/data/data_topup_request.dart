import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/models/transaction_meta_data.dart';

part 'data_topup_request.g.dart';

@JsonSerializable(includeIfNull: false)
class DataTopUpRequest  {

  @JsonKey(name:"customerId")
  String? phoneNumber;

  @JsonKey(name:"dataProviderItemCode")
  String? dataProviderItemCode;

  @JsonKey(name:"dataProviderName")
  String? dataProviderName;

  @JsonKey(name:"minorCreditAmount")
  double? minorCreditAmount;

  @JsonKey(name:"name")
  String? name;

  @JsonKey(name: "location")
  Location? location;

  DataTopUpRequest({this.phoneNumber,
      this.dataProviderItemCode,
      this.dataProviderName,
      this.minorCreditAmount,
      this.name,
      this.location
  });

  factory DataTopUpRequest.fromJson(Object? data) => _$DataTopUpRequestFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$DataTopUpRequestToJson(this);


  DataTopUpRequest withPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    return this;
  }

  DataTopUpRequest withDataProviderItemCode(String serviceProviderCode) {
    this.dataProviderItemCode = serviceProviderCode;
    return this;
  }

  DataTopUpRequest withMinorCreditAmount(double minorCreditAmount) {
    this.minorCreditAmount = minorCreditAmount;
    return this;
  }

  DataTopUpRequest withDataProviderName(String providerName) {
    this.dataProviderName = providerName;
    return this;
  }

  DataTopUpRequest withName(String name) {
    this.name = name;
    return this;
  }

  DataTopUpRequest withLocation(Location? location) {
    this.location = location;
    return this;
  }
}