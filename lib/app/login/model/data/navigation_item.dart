import 'package:json_annotation/json_annotation.dart';

part 'navigation_item.g.dart';

@JsonSerializable()
class NavigationItem {
  String? title;
  String? destination;

   NavigationItem(this.title, this.destination);

   factory NavigationItem.fromJson(Object? data) =>
      _$NavigationItemFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$NavigationItemToJson(this);
}
