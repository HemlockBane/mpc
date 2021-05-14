import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/DropDownItem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'drop_items.g.dart';

class IdentificationType extends DropDownItem {
  final String idType;

  const IdentificationType(this.idType);

  @override
  String getTitle() {
    return this.idType;
  }
}

const identificationTypes = [
  const IdentificationType("National ID"),
  const IdentificationType("Drivers License"),
  const IdentificationType("International Passport"),
  const IdentificationType("Voters Card"),
];


class MaritalStatus extends DropDownItem {
  final String maritalStatus;

  const MaritalStatus(this.maritalStatus);

  @override
  String getTitle() {
    return this.maritalStatus;
  }
}

const maritalStatus = [
  const MaritalStatus("SINGLE"),
  const MaritalStatus("MARRIED"),
  const MaritalStatus("WIDOWED"),
  const MaritalStatus("SEPARATED"),
  const MaritalStatus("DIVORCED"),
];

class Religion extends DropDownItem {
  final String religion;

  const Religion(this.religion);

  @override
  String getTitle() {
    return this.religion;
  }
}

const religion = [
  const Religion("Christianity"),
  const Religion("Islam"),
  const Religion("Other: please specify"),
];


@Entity(tableName: "nationalities")
@JsonSerializable()
class Nationality extends DropDownItem {
  @primaryKey
  @JsonKey(name:"id")
  final int? id;

  @JsonKey(name:"code")
  final String? code;

  @JsonKey(name:"name")
  final String name;

  @JsonKey(name:"postCode")
  final String? postCode;

  @JsonKey(name:"isoCode")
  final String? isoCode;

  @JsonKey(name:"base64Icon")
  final String? base64Icon;

  @JsonKey(name:"active")
  final bool? active;

  @JsonKey(name:"timeAdded")
  final String? timeAdded;

  @TypeConverters([ListConverter])
  @JsonKey(name:"states")
  final List<StateOfOrigin>? states;

  @JsonKey(name:"nationality")
  final String? nationality;

  Nationality(
      this.nationality,
      this.id,
      this.code,
      this.name,
      this.postCode,
      this.isoCode,
      this.base64Icon,
      this.active,
      this.timeAdded,
      this.states
      );


  factory Nationality.fromJson(Object? data) => _$NationalityFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$NationalityToJson(this);

  @override
  String getTitle() {
    return this.name;
  }

}

@JsonSerializable()
class StateOfOrigin extends DropDownItem {
  @JsonKey(name:"id") final int? id;
  @JsonKey(name:"name") final String? name;
  @JsonKey(name:"code") final String? code;
  @JsonKey(name:"active") final bool? active;
  @JsonKey(name:"timeAdded") final String? timeAdded;
  @JsonKey(name:"localGovernmentAreas") final List<LocalGovernmentArea>? localGovernmentAreas;

  StateOfOrigin(this.id, this.name, this.code, this.active, this.timeAdded, this.localGovernmentAreas);

  factory StateOfOrigin.fromJson(Map<String, dynamic> data) => _$StateOfOriginFromJson(data);
  Map<String, dynamic> toJson() => _$StateOfOriginToJson(this);


  @override
  String getTitle() {
    return this.name ?? "";
  }
}


@JsonSerializable()
class LocalGovernmentArea extends DropDownItem {

  @JsonKey(name: "id") final int? id;
  @JsonKey(name: "name") final String? name;
  @JsonKey(name: "code") final String? code;
  @JsonKey(name: "active") final bool? active;
  @JsonKey(name: "timeAdded") final String? timeAdded;

  LocalGovernmentArea(this.id, this.name, this.code, this.active, this.timeAdded);

  factory LocalGovernmentArea.fromJson(Map<String, dynamic> data) => _$LocalGovernmentAreaFromJson(data);
  Map<String, dynamic> toJson() => _$LocalGovernmentAreaToJson(this);

  @override
  String getTitle() {
    return this.name ?? "";
  }

}

class EmploymentStatus extends DropDownItem {
  final String employmentStatus;

  const EmploymentStatus(this.employmentStatus);

  @override
  String getTitle() {
    return this.employmentStatus.replaceAll("_", " ");
  }
}

const employmentStatus = [
  const EmploymentStatus("Unemployed"),
  const EmploymentStatus("Employed"),
  const EmploymentStatus("Self_Employed"),
];

class Titles extends DropDownItem {
  final String title;

  const Titles(this.title);

  @override
  String getTitle() {
    return this.title;
  }
}

const titles = [
  const Titles("Mr."),
  const Titles("Mrs."),
  const Titles("Miss."),
  const Titles("Ms."),
  const Titles("Messrs."),
  const Titles("Dr."),
  const Titles("Dr. (MRS.)"),
  const Titles("Chief"),
  const Titles("Chief (Mrs.)"),
  const Titles("Prof."),
  const Titles("Justice"),
  const Titles("Master"),
  const Titles("Engr."),
  const Titles("Arch."),
  const Titles("Barrister"),
  const Titles("Sir"),
  const Titles("Lady"),
  const Titles("Alhaji"),
  const Titles("Alhaja"),
  const Titles("Sheikh"),
  const Titles("Pastor"),
  const Titles("Reverend"),
  const Titles("Rev. Father"),
  const Titles("Rev. Mother"),
  const Titles("Bishop"),
  const Titles("Evangelist"),
  const Titles("Deacon"),
  const Titles("Oba"),
  const Titles("Lolo"),
  const Titles("His Majesty"),
  const Titles("Her Majesty"),
  const Titles("Otunba"),
  const Titles("Prince"),
  const Titles("Princess"),
  const Titles("His Royal Highness"),
  const Titles("Emir"),
  const Titles("Obi"),
  const Titles("Ogbuefi"),
  const Titles("Mazi"),
  const Titles("Honourable"),
  const Titles("Senator"),
  const Titles("His Excellency"),
  const Titles("Ambassador"),
  const Titles("General (Rtd)"),
  const Titles("Brigadier (Rtd)"),
  const Titles("General"),
  const Titles("Col."),
  const Titles("Wing Cmdr."),
  const Titles("Major"),
  const Titles("Cmdr."),
  const Titles("Sgt."),
  const Titles("Capt."),
  const Titles("Mallam"),
  const Titles("Turaki"),
  const Titles("Yerima"),
  const Titles("Eze"),
];


class Relationship extends DropDownItem {
  final String relationship;

  const Relationship(this.relationship);

  @override
  String getTitle() {
    return this.relationship;
  }
}

const relationship = [
  const Relationship("Husband"),
  const Relationship("Wife"),
  const Relationship("Daughter"),
  const Relationship("Sister"),
  const Relationship("Brother"),
  const Relationship("Son"),
  const Relationship("Father"),
  const Relationship("Mother"),
  const Relationship("Cousin"),
  const Relationship("Uncle"),
  const Relationship("Aunt"),
  const Relationship("Nephew"),
  const Relationship("Niece"),
];
