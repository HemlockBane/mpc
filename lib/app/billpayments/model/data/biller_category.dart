
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';

part 'biller_category.g.dart';

@Entity(tableName: 'biller_categories')
@JsonSerializable()
class BillerCategory  {

  @JsonKey(name:"id")
  @PrimaryKey()
  final int id;

  @JsonKey(name:"name")
  final String? name;

  @JsonKey(name:"description")
  final String? description;

  @JsonKey(name:"categoryCode")
  final String? categoryCode;

  @JsonKey(name:"active")
  final bool? active;

  // @JsonKey(name:"createdOn")
  // @TypeConverters(DateListTypeConverter.class)
  // final ArrayList<Integer> createdOn = null;

  @JsonKey(name:"svgImage")
  final String? svgImage;

  BillerCategory(
      {required this.id,
      this.name,
      this.description,
      this.categoryCode,
      this.active,
      this.svgImage});

  factory BillerCategory.fromJson(Object? data) => _$BillerCategoryFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BillerCategoryToJson(this);

}