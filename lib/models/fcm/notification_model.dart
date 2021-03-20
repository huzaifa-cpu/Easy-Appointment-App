import 'package:flutter_ea_mobile_app/models/user_model.dart';

class NotificationModel {
  int id;
  String title;
  String subTitle;
  String route;
  dynamic createdDate;
  User user;
  String deviceToken;

  NotificationModel(
      {this.id,
      this.createdDate,
      this.title,
      this.user,
      this.route,
      this.deviceToken,
      this.subTitle});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        createdDate: json["createdDate"],
        subTitle: json["subTitle"],
        route: json["route"],
        deviceToken: json["deviceToken"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "createdDate": createdDate,
        "subTitle": subTitle,
        "route": route,
        "deviceToken": deviceToken,
        "user": user.toJson(),
      };
}
