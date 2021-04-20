import 'package:json_annotation/json_annotation.dart';

part 'account_info_request.g.dart';

@JsonSerializable()
class AccountInfoRequestBody {

  AccountInfoRequestBody({this.accountNumber, this.customerId});

  String? accountNumber;
  final String? customerId;

  Map<String, dynamic> toJson() => _$AccountInfoRequestBodyToJson(this);
}
