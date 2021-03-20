import 'package:flutter_ea_mobile_app/models/appointment_model.dart';

class Slot {
  String timeIn12HoursFormat;
  int timeInMinutes;
  int number;
  String status;
  String phone;
  DateTime date;
  bool disable;
  int locationId;
  Appointment appointment;

  Slot(
      {this.timeIn12HoursFormat,
      this.number,
      this.status,
      this.phone,
      this.date,
      this.timeInMinutes,
      this.disable,
      this.locationId,
      this.appointment});

  Map<String, dynamic> toJson() => {
        'timeIn12HoursFormat': timeIn12HoursFormat,
        'number': number,
        'status': status,
        'day': phone,
        'date': date,
        'timeInMinutes': timeInMinutes,
        'disable': disable,
        'locationId': locationId,
        'appointment': appointment
      };

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
      timeIn12HoursFormat: json['timeIn12HoursFormat'],
      number: json['number'],
      status: json['status'],
      phone: json['phone'],
      timeInMinutes: json['timeInMinutes'],
      date: json['date'],
      disable: json['disable'],
      locationId: json['locationId'],
      appointment: json['appointment']);
}
