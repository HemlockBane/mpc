
import 'package:json_annotation/json_annotation.dart';

part 'card_otp_linking_response.g.dart';


@JsonSerializable()
class CardOtpLinkingResponse {

  String? notificationServiceResponseCode;
  String? userCode;

  CardOtpLinkingResponse();

  factory CardOtpLinkingResponse.fromJson(Object? data) => _$CardOtpLinkingResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CardOtpLinkingResponseToJson(this);

}