import 'package:json_annotation/json_annotation.dart';

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

  @JsonKey(name:"metaData")
  String? metaData;


  DataTopUpRequest({this.phoneNumber,
      this.dataProviderItemCode,
      this.dataProviderName,
      this.minorCreditAmount,
      this.name,
      this.metaData
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

  DataTopUpRequest withMetaData(String metaData) {
    this.metaData = metaData;
    return this;
  }
}