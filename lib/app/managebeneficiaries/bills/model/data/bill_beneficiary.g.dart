// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_beneficiary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillBeneficiary _$BillBeneficiaryFromJson(Map<String, dynamic> json) {
  return BillBeneficiary(
    id: json['id'] as int,
    name: json['name'] as String?,
    billerCategoryLogo: json['billerCategoryLogo'] as String?,
    billerCode: json['billerCode'] as String?,
    biller: json['biller'] == null
        ? null
        : Biller.fromJson(json['biller'] as Object),
    billerProducts: (json['billerProducts'] as List<dynamic>?)
        ?.map((e) => BillerProduct.fromJson(e as Object))
        .toList(),
    billerName: json['billerName'] as String?,
    customerIdentity: json['customerIdentity'] as String?,
    frequency: json['frequency'] as int?,
    lastUpdated: json['lastUpdated'] as int?,
  );
}

Map<String, dynamic> _$BillBeneficiaryToJson(BillBeneficiary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'billerCode': instance.billerCode,
      'billerCategoryLogo': instance.billerCategoryLogo,
      'biller': instance.biller,
      'billerProducts': instance.billerProducts,
      'billerName': instance.billerName,
      'customerIdentity': instance.customerIdentity,
      'frequency': instance.frequency,
      'lastUpdated': instance.lastUpdated,
    };
