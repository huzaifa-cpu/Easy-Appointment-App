import 'doctor_model.dart';

class Location {
  Location(
      {this.id,
      this.address,
      this.name,
      this.fee,
      this.clinicType,
      this.state,
      this.status,
      this.createdDate,
      this.updatedDate,
      this.doctor,
      this.schedules});

  int id;
  dynamic address;
  dynamic name;
  int fee;
  int clinicType;
  bool state;
  dynamic status;
  dynamic createdDate;
  dynamic updatedDate;
  Doctor doctor;
  List<dynamic> schedules;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
      id: json["id"],
      address: json["address"],
      name: json["name"],
      fee: json["fee"],
      clinicType: json["clinicType"],
      state: json["state"],
      status: json["status"],
      createdDate: json["createdDate"],
      updatedDate: json["updatedDate"],
      doctor: Doctor.fromJson(json["doctor"]),
      schedules: json["schedules"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "name": name,
        "fee": fee,
        "clinicType": clinicType,
        "state": state,
        "status": status,
        "createdDate": createdDate,
        "updatedDate": updatedDate,
        "doctor": doctor.toJson(),
        "schedules": schedules
      };
}
