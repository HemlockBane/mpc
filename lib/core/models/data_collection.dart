import 'package:json_annotation/json_annotation.dart';

// part 'data_collection.g.dart';

// @JsonSerializable(genericArgumentFactories: true)
abstract class DataCollection<Data> {

  @JsonKey(name:"content")
  List<Data>? content;
  @JsonKey(name:"totalElements")
  int? totalElements;
  @JsonKey(name:"totalPages")
  int? totalPages;
  @JsonKey(name:"last")
  bool? last;
  @JsonKey(name:"size")
  int? size;
  @JsonKey(name:"number")
  int? number;
  @JsonKey(name:"sort")
  Object? sort;
  @JsonKey(name:"first")
  bool? first;
  @JsonKey(name:"numberOfElements")
  int? numberOfElements;

  // DataCollection();
  //
  // factory DataCollection.fromJson(Map<String, dynamic> data, Data Function(Object? json) fromJsonT) => _$DataCollectionFromJson(data, fromJsonT);
  //
  // Map<String, dynamic> toJson(Map<String, dynamic> Function(Data value) toJsonResultType) => _$DataCollectionToJson(this, toJsonResultType);

}