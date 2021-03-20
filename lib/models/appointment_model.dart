import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/patient_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';

class Appointment {
  Appointment(
      {this.id,
      this.name,
      this.slotDate,
      this.slotTime,
      this.slotNumber,
      this.bookingDate,
      this.paymentDate,
      this.rescheduledDate,
      this.reschedulingCount,
      this.cancelledDate,
      this.fee,
      this.type,
      this.createdByDoctor,
      this.state,
      this.status,
      this.createdDate,
      this.updatedDate,
      this.location,
      this.doctor,
      this.patient,
      this.updatedBy,
      this.createdBy,
      this.completedDate});

  dynamic id;
  dynamic name;
  dynamic slotDate;
  dynamic slotTime;
  dynamic slotNumber;
  dynamic bookingDate;
  dynamic paymentDate;
  dynamic rescheduledDate;
  dynamic reschedulingCount;
  dynamic cancelledDate;
  dynamic completedDate;
  dynamic fee;
  dynamic type;
  dynamic createdByDoctor;
  dynamic state;
  dynamic status;
  dynamic createdDate;
  dynamic updatedDate;
  Location location;
  Doctor doctor;
  Patient patient;
  User updatedBy;
  User createdBy;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        name: json["name"],
        slotDate: json["slotDate"],
        slotTime: json["slotTime"],
        slotNumber: json["slotNumber"],
        bookingDate: json["bookingDate"],
        paymentDate: json["paymentDate"],
        rescheduledDate: json["rescheduledDate"],
        reschedulingCount: json["reschedulingCount"],
        cancelledDate: json["cancelledDate"],
        fee: json["fee"],
        type: json["type"],
        createdByDoctor: json["createdByDoctor"],
        state: json["state"],
        status: json["status"],
        createdDate: json["createdDate"],
        updatedDate: json["updatedDate"],
        completedDate: json['completedDate'],
        location: Location.fromJson(json["location"]),
        doctor: Doctor.fromJson(json["doctor"]),
        patient: Patient.fromJson(json["patient"]),
        updatedBy: User.fromJson(json["updatedBy"]),
        createdBy: User.fromJson(json["createdBy"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slotDate": slotDate,
        "slotTime": slotTime,
        "slotNumber": slotNumber,
        "bookingDate": bookingDate,
        "paymentDate": paymentDate,
        "rescheduledDate": rescheduledDate,
        "reschedulingCount": reschedulingCount,
        "cancelledDate": cancelledDate,
        "fee": fee,
        "type": type,
        "completedDate": completedDate,
        "createdByDoctor": createdByDoctor,
        "state": state,
        "status": status,
        "createdDate": createdDate,
        "updatedDate": updatedDate,
        "location": location.toJson(),
        "doctor": doctor.toJson(),
        "patient": patient.toJson(),
        "updatedBy": updatedBy.toJson(),
        "createdBy": createdBy.toJson(),
      };
}
