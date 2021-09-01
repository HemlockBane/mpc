import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/DropDownItem.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/strings.dart';

part 'drop_items.g.dart';

class IdentificationType extends DropDownItem {
  final String idType;

  const IdentificationType(this.idType);

  factory IdentificationType.fromString(String? id) {
    return identificationTypes.firstWhere(
            (element) => element.idType == id,
        orElse: () => identificationTypes.first
    );
  }

  @override
  String getTitle() {
    return this.idType;
  }
}

final identificationTypes = [
  const IdentificationType("National ID"),
  const IdentificationType("Drivers License"),
  const IdentificationType("International Passport"),
  const IdentificationType("Voters Card"),
]..sort((a, b) => a.idType.compareTo(b.idType));


class MaritalStatus extends DropDownItem {
  final String maritalStatus;

  const MaritalStatus(this.maritalStatus);
  
  factory MaritalStatus.fromString(String? status) {
    return maritalStatuses.firstWhere(
            (element) => element.maritalStatus == status,
        orElse:() => maritalStatuses.first
    );
  }

  @override
  String getTitle() {
    return this.maritalStatus;
  }
}

final maritalStatuses = [
  const MaritalStatus("SINGLE"),
  const MaritalStatus("MARRIED"),
  const MaritalStatus("WIDOWED"),
  const MaritalStatus("SEPARATED"),
  const MaritalStatus("DIVORCED"),
]..sort((a, b) => a.maritalStatus.compareTo(b.maritalStatus));

class Religion extends DropDownItem {
  final String religion;

  const Religion(this.religion);

  factory Religion.fromString(String? religion) {
    return religions.firstWhere((element) => element.religion == religion, orElse: () => religions.first);
  }

  @override
  String getTitle() {
    return this.religion.toLowerCase().capitalizeFirstOfEach;
  }
}

const religions = [
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

  @TypeConverters([ListStateConverter])
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

  static Nationality? fromNationalityName(String? nationality, List<Nationality> nationalities) {
    final nationalityList = nationalities.where((element) => element.nationality == nationality);
    return (nationalityList.isNotEmpty) ? nationalityList.first : null;
  }

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

  factory StateOfOrigin.fromName(String? name, List<StateOfOrigin> states) {
    return states.firstWhere((element) => element.name == name,
        orElse: () => states.first);
  }

  static StateOfOrigin? fromLocalGovtId(int? localGovtId, List<StateOfOrigin> states) {
    print(states.length);
    final stateList = states.where((element) {
      return element.localGovernmentAreas?.any((element) => element.id == localGovtId) ?? false;
    });
    return (stateList.isNotEmpty) ? stateList.first : null;
  }

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

  static LocalGovernmentArea? fromId(int? id, List<LocalGovernmentArea> localGovernments) {
    final localGovtList = localGovernments.where((element) => element.id == id);
    return (localGovtList.isNotEmpty) ? localGovtList.first : null;
  }

  @override
  String getTitle() {
    return this.name ?? "";
  }

}

class EmploymentStatus extends DropDownItem {
  final String empStatus;

  const EmploymentStatus(this.empStatus);
  
  factory EmploymentStatus.fromString(String? employment) {
    return employmentStatus.firstWhere((element) => element.empStatus == employment, orElse: () => employmentStatus.first);
  }

  @override
  String getTitle() {
    return this.empStatus.replaceAll("_", " ").capitalizeFirstOfEach;
  }
}

const employmentStatus = [
  const EmploymentStatus("EMPLOYED"),
  const EmploymentStatus("SELF_EMPLOYED"),
  const EmploymentStatus("UNEMPLOYED"),
];

class Titles extends DropDownItem {
  final String title;

  const Titles(this.title);

  factory Titles.fromTitle(String? title) {
    return titles.firstWhere((element) => element.title == title, orElse: () => titles.first);
  }

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
];//..sort((a, b) => a.title.compareTo(b.title));


class Relationship extends DropDownItem {
  final String relationship;

  const Relationship(this.relationship);

  static Relationship? fromString(String? title) {
    final mRelationships = relationships.where((element) => element.relationship == title);
    return (mRelationships.isNotEmpty) ? mRelationships.first : null;
  }

  @override
  String getTitle() {
    return this.relationship;
  }
}

final relationships = [
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
]..sort((a, b) => a.relationship.compareTo(b.relationship));
