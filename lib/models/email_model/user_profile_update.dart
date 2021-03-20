import 'package:flutter_ea_mobile_app/services/email_service.dart';

class UserProfileUpdate {
  UserProfileUpdate({
    this.from,
    this.to,
    this.html,
    this.template,
    this.templateName,
    this.subject,
    this.parameterMap,
    this.staticResourceMap,
  });

  String from;
  List<String> to;
  bool html;
  bool template;
  String templateName;
  String subject;
  ParameterMap parameterMap;
  StaticResourceMap staticResourceMap;

  factory UserProfileUpdate.fromJson(Map<String, dynamic> json) =>
      UserProfileUpdate(
        from: json["from"],
        to: List<String>.from(json["to"].map((x) => x)),
        html: json["html"],
        template: json["template"],
        templateName: json["templateName"],
        subject: json["subject"],
        parameterMap: ParameterMap.fromJson(json["parameterMap"]),
        staticResourceMap:
            StaticResourceMap.fromJson(json["staticResourceMap"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": List<dynamic>.from(to.map((x) => x)),
        "html": html,
        "template": template,
        "templateName": templateName,
        "subject": subject,
        "parameterMap": parameterMap.toJson(),
        "staticResourceMap": staticResourceMap.toJson(),
      };
}

class ParameterMap {
  ParameterMap({
    this.firstName,
    this.companyWebsiteLink,
    this.companyName,
  });

  String firstName;
  String companyWebsiteLink;
  String companyName;

  factory ParameterMap.fromJson(Map<String, dynamic> json) => ParameterMap(
        firstName: json["firstName"],
        companyWebsiteLink: json["companyWebsiteLink"],
        companyName: json["companyName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "companyWebsiteLink": companyWebsiteLink,
        "companyName": companyName,
      };
}
