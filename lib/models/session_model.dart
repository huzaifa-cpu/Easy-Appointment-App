import 'package:flutter_ea_mobile_app/models/user_model.dart';

class Session {
  int id;
  String status;
  String deviceToken;
  String deviceType;
  DateTime startDate;
  DateTime endDate;
  User user;

  Session(
      {this.id,
      this.status,
      this.user,
      this.deviceToken,
      this.deviceType,
      this.endDate,
      this.startDate});

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json["id"],
        status: json["status"],
        deviceToken: json["deviceToken"],
        deviceType: json["deviceType"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "deviceToken": deviceToken,
        "deviceType": deviceType,
        "startDate": startDate,
        "endDate": endDate,
        "user": user == null ? null : user.toJson(),
      };
}
