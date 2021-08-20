import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_error.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';

import 'package:json_annotation/json_annotation.dart';

part 'card_linking_response.g.dart';

@JsonSerializable()
class CardLinkingResponse extends LivelinessValidationResponse {

  @JsonKey(name: "issuanceCode")
  String? issuanceCode;

  CardLinkingResponse();

  factory CardLinkingResponse.fromJson(Object? data) => _$CardLinkingResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CardLinkingResponseToJson(this);

}