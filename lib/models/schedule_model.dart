import 'package:flutter_ea_mobile_app/models/location_model.dart';

class Schedule {
  int id;
  String name;
  int day;
  int startTime;
  int endTime;
  int defaultTimeSlotLimit;
  bool off;
  bool state;
  String status;
  dynamic createdDate;
  DateTime updatedDate;

  Location location;

  Schedule(
      {this.status,
      this.state,
      this.name,
      this.updatedDate,
      this.createdDate,
      this.id,
      this.day,
      this.defaultTimeSlotLimit,
      this.endTime,
      this.off,
      this.startTime,
      this.location});

  Map<String, dynamic> toJson() => {
        'status': status,
        'state': state,
        'name': name,
        'updatedDate': updatedDate,
        'createdDate': createdDate,
        'id': id,
        'day': day,
        'defaultTimeSlotLimit': defaultTimeSlotLimit,
        'endTime': endTime,
        'off': off,
        'startTime': startTime,
        'location': location.toJson(),
      };

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        status: json['status'],
        state: json['state'],
        name: json['name'],
        updatedDate: json['updatedDate'],
        createdDate: json['createdDate'],
        id: json['id'],
        day: json['day'],
        defaultTimeSlotLimit: json['defaultTimeSlotLimit'],
        endTime: json['endTime'],
        off: json['off'],
        startTime: json['startTime'],
        location: Location.fromJson(json['location']),
      );
}
