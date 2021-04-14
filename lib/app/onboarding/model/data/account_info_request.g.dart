// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInfoRequestBody _$AccountInfoRequestBodyFromJson(
    Map<String, dynamic> json) {
  return AccountInfoRequestBody(
    accountNumber: json['accountNumber'] as String?,
    customerId: json['customerId'] as String?,
  );
}

Map<String, dynamic> _$AccountInfoRequestBodyToJson(
        AccountInfoRequestBody instance) =>
    <String, dynamic>{
      'accountNumber': instance.accountNumber,
      'customerId': instance.customerId,
    };
