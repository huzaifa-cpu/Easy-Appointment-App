import 'package:flutter_ea_mobile_app/models/user_model.dart';

class Doctor {
  Doctor({
    this.id,
    this.registrationNo,
    this.fatherName,
    this.registrationDate,
    this.registrationType,
    this.validUpto,
    this.qualifications,
    this.titlesStr,
    this.degreesStr,
    this.titles,
    this.degrees,
    this.practiceStartingDate,
    this.description,
    this.createdDate,
    this.updatedDate,
    this.user,
    this.locations,
  });

  int id;
  String registrationNo;
  String fatherName;
  String registrationDate;
  String registrationType;
  String validUpto;
  dynamic qualifications;
  dynamic titlesStr;
  dynamic degreesStr;
  List<dynamic> titles;
  List<dynamic> degrees;
  dynamic practiceStartingDate;
  dynamic description;
  dynamic createdDate;
  dynamic updatedDate;
  User user;
  List<dynamic> locations;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        registrationNo: json["registrationNo"],
        fatherName: json["fatherName"],
        registrationDate: json["registrationDate"],
        registrationType: json["registrationType"],
        validUpto: json["validUpto"],
        qualifications: json["qualifications"],
        titlesStr: json["titlesStr"],
        degreesStr: json["degreesStr"],
        titles: json["titles"],
        degrees: json["degrees"],
        practiceStartingDate: json["practiceStartingDate"],
        description: json["description"],
        createdDate: json["createdDate"],
        updatedDate: json["updatedDate"],
        user: User.fromJson(json["user"]),
        locations: json["locations"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registrationNo": registrationNo,
        "fatherName": fatherName,
        "registrationDate": registrationDate,
        "registrationType": registrationType,
        "validUpto": validUpto,
        "qualifications": qualifications,
        "titlesStr": titlesStr,
        "degreesStr": degreesStr,
        "titles": titles,
        "degrees": degrees,
        "practiceStartingDate": practiceStartingDate,
        "description": description,
        "createdDate": createdDate,
        "updatedDate": updatedDate,
        "user": user.toJson() ?? "",
        "locations": locations,
      };
}
