// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillTransaction _$BillTransactionFromJson(Map<String, dynamic> json) {
  return BillTransaction(
    id: json['id'] as int?,
    minorAmount: json['minorAmount'] as int?,
    sourceAccountProviderName: json['sourceAccountProviderName'] as String?,
    sourceAccountNumber: json['sourceAccountNumber'] as String?,
    sourceAccountCurrencyCode: json['sourceAccountCurrencyCode'] as String?,
    transactionStatus: json['transactionStatus'] as String?,
    transactionTime: stringDateTime(json['transactionTime'] as String),
    customerId: json['customerId'] as String?,
    customerIdName: json['customerIdName'] as String?,
    billerCategoryName: json['billerCategoryName'] as String?,
    billerCategoryCode: json['billerCategoryCode'] as String?,
    billerName: json['billerName'] as String?,
    billerCode: json['billerCode'] as String?,
    billerLogoUUID: json['billerLogoUUID'] as String?,
    billerProductName: json['billerProductName'] as String?,
    billerProductCode: json['billerProductCode'] as String?,
    transactionId: json['transactionId'] as String?,
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$BillTransactionToJson(BillTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'minorAmount': instance.minorAmount,
      'sourceAccountProviderName': instance.sourceAccountProviderName,
      'sourceAccountNumber': instance.sourceAccountNumber,
      'sourceAccountCurrencyCode': instance.sourceAccountCurrencyCode,
      'transactionStatus': instance.transactionStatus,
      'transactionTime': millisToString(instance.transactionTime),
      'customerId': instance.customerId,
      'customerIdName': instance.customerIdName,
      'billerCategoryName': instance.billerCategoryName,
      'billerCategoryCode': instance.billerCategoryCode,
      'billerName': instance.billerName,
      'billerCode': instance.billerCode,
      'billerLogoUUID': instance.billerLogoUUID,
      'billerProductName': instance.billerProductName,
      'billerProductCode': instance.billerProductCode,
      'transactionId': instance.transactionId,
      'token': instance.token,
    };
