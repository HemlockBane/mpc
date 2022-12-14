// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..accessToken = json['access_token'] as String?
    ..tokenType = json['token_type'] as String?
    ..expiresIn = json['expiresIn'] as int?
    ..scope = json['scope'] as String?
    ..lastLogin = json['lastLogin'] as int?
    ..lastName = json['lastName'] as String?
    ..registerDevice = json['registerDevice'] as bool?
    ..securityFlags = json['securityFlags'] == null
        ? null
        : SecurityFlags.fromJson(json['securityFlags'] as Object)
    ..fullName = json['fullName'] as String?
    ..firstName = json['firstName'] as String?
    ..phoneNumber = json['phoneNumber'] as String?
    ..isValidated = json['isValidated'] as bool?
    ..response = json['response'] as String?
    ..middleName = json['middleName'] as String?
    ..customers = (json['customers'] as List<dynamic>?)
        ?.map((e) => Customer.fromJson(e as Object))
        .toList()
    ..email = json['email'] as String?
    ..username = json['username'] as String?
    ..loginPrompts = (json['loginCommandPrompts'] as List<dynamic>?)
        ?.map((e) => LoginPrompt.fromJson(e as Object))
        .toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expiresIn': instance.expiresIn,
      'scope': instance.scope,
      'lastLogin': instance.lastLogin,
      'lastName': instance.lastName,
      'registerDevice': instance.registerDevice,
      'securityFlags': instance.securityFlags,
      'fullName': instance.fullName,
      'firstName': instance.firstName,
      'phoneNumber': instance.phoneNumber,
      'isValidated': instance.isValidated,
      'response': instance.response,
      'middleName': instance.middleName,
      'customers': instance.customers,
      'email': instance.email,
      'username': instance.username,
      'loginCommandPrompts': instance.loginPrompts,
    };
