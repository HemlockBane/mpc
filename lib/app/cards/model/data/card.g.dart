// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) {
  return Card(
    id: json['id'] as int?,
    idFromCardService: json['idFromCardService'] as int?,
    encryptedPan: json['status'] as String?,
    maskedPan: json['maskedPan'] as String,
    hashedPan: json['hashedPan'] as String?,
    expiryDate: json['expiryDate'] as String?,
    branchCode: json['branchCode'] as String?,
    dateActivated: json['dateActivated'] as String?,
    dateIssued: json['dateIssued'] as String?,
    issuerReference: json['issuerReference'] as String?,
    nameOnCard: json['nameOnCard'] as String?,
    defaultAccountType: json['defaultAccountType'] as String?,
    cardProgram: json['cardProgram'] as String?,
    channelBlockStatus: json['transactionChannelBlockStatus'] == null
        ? null
        : TransactionChannelBlockStatus.fromJson(
            json['transactionChannelBlockStatus'] as Object),
    cardProduct: json['cardProduct'] == null
        ? null
        : CardProduct.fromJson(json['cardProduct'] as Object),
    sequenceNumber: json['sequenceNumber'] as String?,
    cardAccountNumber: json['cardAccountNumber'] as String?,
    customerAccountCard: json['customerAccountCard'] == null
        ? null
        : CustomerAccountCard.fromJson(json['customerAccountCard'] as Object),
    cardRequestBatch: json['cardRequestBatch'] as String?,
    blockReason: json['blockReason'] as String?,
    issued: json['issued'] as bool?,
    isActivated: json['isActivated'] as bool,
    blocked: json['blocked'] as bool,
  );
}

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'id': instance.id,
      'idFromCardService': instance.idFromCardService,
      'status': instance.encryptedPan,
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
      'isActivated': instance.isActivated,
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
  return TransactionChannelBlockStatus(
    web: json['web'] as bool,
    pos: json['pos'] as bool,
    atm: json['atm'] as bool,
  );
}

Map<String, dynamic> _$TransactionChannelBlockStatusToJson(
        TransactionChannelBlockStatus instance) =>
    <String, dynamic>{
      'pos': instance.pos,
      'web': instance.web,
      'atm': instance.atm,
    };
