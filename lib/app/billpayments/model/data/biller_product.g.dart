// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biller_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillerProduct _$BillerProductFromJson(Map<String, dynamic> json) {
  return BillerProduct(
    billerCode: json['billerCode'] as String?,
    id: json['id'] as int,
    name: json['name'] as String?,
    code: json['code'] as String?,
    amount: (json['amount'] as num?)?.toDouble(),
    fee: (json['fee'] as num?)?.toDouble(),
    paymentCode: json['paymentCode'] as String?,
    currencySymbol: json['currencySymbol'] as String?,
    active: json['active'] as bool?,
    priceFixed: json['priceFixed'] as bool?,
    minimumAmount: (json['minimumAmount'] as num?)?.toDouble(),
    maximumAmount: (json['maximumAmount'] as num?)?.toDouble(),
    identifierName: json['identifierName'] as String?,
    additionalFieldsMap:
        (json['additionalFieldsMap'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, InputField.fromJson(e as Object)),
    ),
    billerName: json['billerName'] as String?,
  );
}

Map<String, dynamic> _$BillerProductToJson(BillerProduct instance) =>
    <String, dynamic>{
      'billerCode': instance.billerCode,
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'amount': instance.amount,
      'fee': instance.fee,
      'paymentCode': instance.paymentCode,
      'currencySymbol': instance.currencySymbol,
      'active': instance.active,
      'priceFixed': instance.priceFixed,
      'minimumAmount': instance.minimumAmount,
      'maximumAmount': instance.maximumAmount,
      'identifierName': instance.identifierName,
      'additionalFieldsMap': instance.additionalFieldsMap,
      'billerName': instance.billerName,
    };

InputField _$InputFieldFromJson(Map<String, dynamic> json) {
  return InputField(
    json['dataType'] as String,
    json['required'] as bool,
    (json['minimumLength'] as num?)?.toDouble(),
    (json['maximumLength'] as num?)?.toDouble(),
    key: json['key'] as String?,
    fieldLabel: json['fieldLabel'] as String?,
    fieldError: json['fieldError'] as String?,
    fieldValue: json['fieldValue'] as String?,
  );
}

Map<String, dynamic> _$InputFieldToJson(InputField instance) =>
    <String, dynamic>{
      'key': instance.key,
      'fieldLabel': instance.fieldLabel,
      'fieldError': instance.fieldError,
      'fieldValue': instance.fieldValue,
      'dataType': instance.dataType,
      'required': instance.required,
      'minimumLength': instance.minimumLength,
      'maximumLength': instance.maximumLength,
    };
