import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'biller.g.dart';

@Entity(tableName: 'billers')
@JsonSerializable()
class Biller {
  @JsonKey(name:"billerCategoryName")
  final String? billerCategoryId;

  String? billerCategoryCode;

  @JsonKey(name:"id")
  @PrimaryKey()
  final int id;

  @JsonKey(name:"name")
  final String? name;

  @JsonKey(name:"code")
  final String? code;

  @JsonKey(name:"identifierName")
  final String? identifierName;

  @JsonKey(name:"currencySymbol")
  final String? currencySymbol;

  @JsonKey(name:"active")
  final bool? active;

  @JsonKey(name:"collectionAccountNumber")
  final String? collectionAccountNumber;

  @JsonKey(name:"collectionAccountName")
  final String? collectionAccountName;

  @JsonKey(name:"collectionAccountProviderCode")
  final String? collectionAccountProviderCode;

  @JsonKey(name:"collectionAccountProviderName")
  final String? collectionAccountProviderName;

  // @JsonKey(name:"createdOn")
  // @TypeConverters([DateListTypeConverter.class])
  // final List<int>? createdOn = null;

  @JsonKey(name:"svgImage")
  final String? svgImage;

  Biller(
      {this.billerCategoryId,
      this.billerCategoryCode,
      required this.id,
      this.name,
      this.code,
      this.identifierName,
      this.currencySymbol,
      this.active,
      this.collectionAccountNumber,
      this.collectionAccountName,
      this.collectionAccountProviderCode,
      this.collectionAccountProviderName,
      this.svgImage});

  factory Biller.fromJson(Object? data) => _$BillerFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BillerToJson(this);

  // @Override
  // public boolean equals(Object obj) {
  //   if (!(obj instanceof Biller)) {
  //     return false;
  //   }
  //
  //   Biller other = (Biller) obj;
  //   return this.name.equals(other.name) && this.code.equals(other.code);
  // }

}