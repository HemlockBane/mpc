// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) {
  return Card(
    json['id'] as int?,
    json['status'] as String?,
    json['encryptedPan'] as String?,
    json['maskedPan'] as String,
    json['hashedPan'] as String?,
    json['expiryDate'] as String?,
    json['branchCode'] as String?,
    json['dateActivated'] as String?,
    json['dateIssued'] as String?,
    json['issuerReference'] as String?,
    json['nameOnCard'] as String?,
    json['defaultAccountType'] as String?,
    json['cardProgram'] as String?,
    json['transactionChannelBlockStatus'] == null
        ? null
        : TransactionChannelBlockStatus.fromJson(
            json['transactionChannelBlockStatus'] as Object),
    json['cardProduct'] == null
        ? null
        : CardProduct.fromJson(json['cardProduct'] as Object),
    json['sequenceNumber'] as String?,
    json['cardAccountNumber'] as String?,
    json['customerAccountCard'] == null
        ? null
        : CustomerAccountCard.fromJson(json['customerAccountCard'] as Object),
    json['cardRequestBatch'] as String?,
    json['blockReason'] as String?,
    json['issued'] as bool?,
  )..blocked = json['blocked'] as bool;
}

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'encryptedPan': instance.encryptedPan,
      'maskedPan': instance.maskedPan,
      'hashedPan': instance.hashedPan,
      'expiryDate': instance.expiryDate,
      'branchCode': instance.branchCode,
      'dateActivated': instance.dateActivated,
      'dateIssued': instance.dateIssued,
      'issuerReference': instance.issuerReference,
      'nameOnCard': instance.nameOnCard,
      'defaultAccountType': instance.defaultAccountType,
      'cardProgram': instance.cardProgram,
      'transactionChannelBlockStatus': instance.channelBlockStatus,
      'cardProduct': instance.cardProduct,
      'sequenceNumber': instance.sequenceNumber,
      'cardAccountNumber': instance.cardAccountNumber,
      'customerAccountCard': instance.customerAccountCard,
      'cardRequestBatch': instance.cardRequestBatch,
      'blocked': instance.blocked,
      'blockReason': instance.blockReason,
      'issued': instance.issued,
    };

CardProduct _$CardProductFromJson(Map<String, dynamic> json) {
  return CardProduct()
    ..id = json['id'] as int?
    ..status = json['status'] as String?
    ..createdOn = json['createdOn'] as String?
    ..lastModifiedOn = json['lastModifiedOn'] as String?
    ..name = json['name'] as String?
    ..code = json['code'] as String?;
}

Map<String, dynamic> _$CardProductToJson(CardProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'createdOn': instance.createdOn,
      'lastModifiedOn': instance.lastModifiedOn,
      'name': instance.name,
      'code': instance.code,
    };

CustomerAccountCard _$CustomerAccountCardFromJson(Map<String, dynamic> json) {
  return CustomerAccountCard()
    ..id = json['id'] as int?
    ..status = json['status'] as String?
    ..createdOn = json['createdOn'] as String?
    ..lastModifiedOn = json['lastModifiedOn'] as String?
    ..customerAccountNumber = json['customerAccountNumber'] as String?
    ..customerAccountType = json['customerAccountType'] as String?;
}

Map<String, dynamic> _$CustomerAccountCardToJson(
        CustomerAccountCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'createdOn': instance.createdOn,
      'lastModifiedOn': instance.lastModifiedOn,
      'customerAccountNumber': instance.customerAccountNumber,
      'customerAccountType': instance.customerAccountType,
    };

TransactionChannelBlockStatus _$TransactionChannelBlockStatusFromJson(
    Map<String, dynamic> json) {
  return TransactionChannelBlockStatus()
    ..pos = json['pos'] as bool
    ..web = json['web'] as bool
    ..atm = json['atm'] as bool;
}

Map<String, dynamic> _$TransactionChannelBlockStatusToJson(
        TransactionChannelBlockStatus instance) =>
    <String, dynamic>{
      'pos': instance.pos,
      'web': instance.web,
      'atm': instance.atm,
    };
