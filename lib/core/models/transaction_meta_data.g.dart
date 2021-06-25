// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionMetaData _$TransactionMetaDataFromJson(Map<String, dynamic> json) {
  return TransactionMetaData(
    location: json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Object),
    recipient: json['recipient'] == null
        ? null
        : Recipient.fromJson(json['recipient'] as Object),
    transactionType: json['transactionType'] as String?,
  );
}

Map<String, dynamic> _$TransactionMetaDataToJson(TransactionMetaData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('location', instance.location);
  writeNotNull('recipient', instance.recipient);
  writeNotNull('transactionType', instance.transactionType);
  return val;
}

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    latitude: json['latitude'] as String?,
    longitude: json['longitude'] as String?,
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  return val;
}

Recipient _$RecipientFromJson(Map<String, dynamic> json) {
  return Recipient(
    name: json['name'] as String?,
    accountNumber: json['accountNumber'] as String?,
    bankName: json['bankName'] as String?,
    bankCode: json['bankCode'] as String?,
  );
}

Map<String, dynamic> _$RecipientToJson(Recipient instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('accountNumber', instance.accountNumber);
  writeNotNull('bankName', instance.bankName);
  writeNotNull('bankCode', instance.bankCode);
  return val;
}
