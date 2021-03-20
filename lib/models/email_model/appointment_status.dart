import 'package:flutter_ea_mobile_app/services/email_service.dart';

class AppointmentStatus {
  AppointmentStatus({
    this.from,
    this.html,
    this.parameterMap,
    this.staticResourceMap,
    this.subject,
    this.template,
    this.templateName,
    this.to,
  });

  String from;
  bool html;
  ParameterMapAppointment parameterMap;
  StaticResourceMap staticResourceMap;
  String subject;
  bool template;
  String templateName;
  List<String> to;

  factory AppointmentStatus.fromJson(Map<String, dynamic> json) =>
      AppointmentStatus(
        from: json["from"],
        html: json["html"],
        parameterMap: ParameterMapAppointment.fromJson(json["parameterMap"]),
        staticResourceMap:
            StaticResourceMap.fromJson(json["staticResourceMap"]),
        subject: json["subject"],
        template: json["template"],
        templateName: json["templateName"],
        to: List<String>.from(json["to"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "html": html,
        "parameterMap": parameterMap.toJson(),
        "staticResourceMap": staticResourceMap.toJson(),
        "subject": subject,
        "template": template,
        "templateName": templateName,
        "to": List<dynamic>.from(to.map((x) => x)),
      };
}

class ParameterMapAppointment {
  ParameterMapAppointment({
    this.firstName,
    this.secondName,
    this.date,
    this.time,
    this.status,
    this.companyWebsiteLink,
    this.companyName,
  });

  String firstName;
  String secondName;
  String date;
  String time;
  String status;
  String companyWebsiteLink;
  String companyName;

  factory ParameterMapAppointment.fromJson(Map<String, dynamic> json) =>
      ParameterMapAppointment(
        firstName: json["firstName"],
        secondName: json["secondName"],
        date: json["date"],
        time: json["time"],
        status: json["status"],
        companyWebsiteLink: json["companyWebsiteLink"],
        companyName: json["companyName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "secondName": secondName,
        "date": date,
        "time": time,
        "status": status,
        "companyWebsiteLink": companyWebsiteLink,
        "companyName": companyName,
      };
}
