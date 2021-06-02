import 'package:json_annotation/json_annotation.dart';

part 'airtime_data_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AirtimeDataRequest {

  @JsonKey(name:"phoneNumber")
  String? phoneNumber;

  @JsonKey(name:"serviceProviderCode")
  String? serviceProviderCode;

  @JsonKey(name:"minorCreditAmount")
  double? minorCreditAmount;

  @JsonKey(name:"name")
  String? name;

  @JsonKey(name:"metaData")
  String? metaData;

  AirtimeDataRequest();

  AirtimeDataRequest withPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    return this;
  }

  AirtimeDataRequest withServiceProviderCode(String serviceProviderCode) {
    this.serviceProviderCode = serviceProviderCode;
    return this;
  }

  AirtimeDataRequest withMinorCreditAmount(double minorCreditAmount) {
    this.minorCreditAmount = minorCreditAmount;
    return this;
  }

  factory AirtimeDataRequest.fromJson(Object? data) => _$AirtimeDataRequestFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AirtimeDataRequestToJson(this);

}