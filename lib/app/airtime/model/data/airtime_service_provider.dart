import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'airtime_service_provider.g.dart';

@Entity(tableName: "service_providers", primaryKeys: ["code"])
@JsonSerializable()
class AirtimeServiceProvider {
  @JsonKey(name: "code")
  final String code;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "currencySymbol")
  final String? currencySymbol;

  @JsonKey(name: "billerId")
  final String? billerId;

  @JsonKey(name: "identifierName")
  final String? identifierName;

  @JsonKey(name: "svgImage")
  final String? svgImage;

  @JsonKey(name: "logoImageUUID")
  final String? logoImageUUID;

  @ignore
  bool? isSelected;

  AirtimeServiceProvider({required this.code,
      this.name,
      this.currencySymbol,
      this.billerId,
      this.identifierName,
      this.svgImage,
      this.logoImageUUID
  });

  factory AirtimeServiceProvider.fromJson(Object? data) => _$AirtimeServiceProviderFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$AirtimeServiceProviderToJson(this);

//
// AirtimeServiceProvider toAirtimeServiceProvider() {
//   return new AirtimeServiceProvider(
//       this.name,
//       this.code,
//       this.currencySymbol,
//       this.billerId,
//       this.identifierName,
//       this.svgImage
//   );
// }
//
// DataServiceProvider toDataServiceProvider() {
//   return new DataServiceProvider(
//       this.name,
//       this.code,
//       this.currencySymbol,
//       this.billerId,
//       this.identifierName,
//       true
//   );
// }

}
