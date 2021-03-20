import 'package:flutter_ea_mobile_app/models/user_model.dart';

class Patient {
  Patient({
    this.id,
    this.preference,
    this.createdDate,
    this.updatedDate,
    this.user,
  });

  dynamic id;
  dynamic preference;
  dynamic createdDate;
  dynamic updatedDate;
  User user;

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        preference: json["preference"],
        createdDate: json["createdDate"],
        updatedDate: json["updatedDate"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "preference": preference,
        "createdDate": createdDate,
        "updatedDate": updatedDate,
        "user": user.toJson(),
      };
}
