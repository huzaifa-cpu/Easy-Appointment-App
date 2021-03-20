import 'package:flutter_ea_mobile_app/models/appointment_model.dart';

class Payment {
  Payment({
    this.id,
    this.name,
    this.amount,
    this.type,
    this.appointment,
    this.state,
    this.status,
    this.createdDate,
    this.updatedDate,
  });

  int id;
  String name;
  int amount;
  String type;
  Appointment appointment;
  bool state;
  String status;
  dynamic createdDate;
  dynamic updatedDate;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        name: json["name"],
        amount: json["amount"],
        type: json["type"],
        appointment: Appointment.fromJson(json["appointment"]),
        state: json["state"],
        status: json["status"],
        createdDate: json["createdDate"],
        updatedDate: json["updatedDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
        "type": type,
        "appointment": appointment.toJson(),
        "state": state,
        "status": status,
        "createdDate": createdDate,
        "updatedDate": updatedDate,
      };
}
