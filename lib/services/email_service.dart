import 'dart:convert';

import 'package:flutter_ea_mobile_app/models/email_model/appointment_status.dart';
import 'package:flutter_ea_mobile_app/models/email_model/user_profile_update.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';

class EmailService {
  CustomStrings strings = CustomStrings();

  //USER_PROFILE_UPDATE
  Future userProfileUpdated(String to, String name) async {
    ParameterMap parameterMap = ParameterMap(
      firstName: name,
      companyWebsiteLink: strings.companyWebsiteLink,
      companyName: strings.companyName,
    );
    UserProfileUpdate userProfileUpdate = UserProfileUpdate(
      from: strings.emailFrom,
      to: [to],
      html: true,
      template: true,
      templateName: "user-profile-update",
      subject: "Profile Update",
      parameterMap: parameterMap,
      staticResourceMap: StaticResourceMap(),
    );
    var jsonValue = jsonEncode(userProfileUpdate);
    Response response = await post('${strings.apiEndpoint}/send-html-email',
        body: jsonValue,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
    } else {
      throw "can't post";
    }
  }

  // //APPOINTMENT-COMPLETION
  // Future appointmentCompletion(String to, String name) async {
  //   ParameterMap parameterMap = ParameterMap(
  //     firstName: name,
  //     companyWebsiteLink: strings.companyWebsiteLink,
  //     companyName: strings.companyName,
  //   );
  //   UserProfileUpdate userProfileUpdate = UserProfileUpdate(
  //     from: strings.emailFrom,
  //     to: [to],
  //     html: true,
  //     template: true,
  //     templateName: "appointment-completion",
  //     subject: "Appointment Completed",
  //     parameterMap: parameterMap,
  //     staticResourceMap: StaticResourceMap(),
  //   );
  //   var jsonValue = jsonEncode(userProfileUpdate);
  //   Response response = await post('${strings.apiEndpoint}/send-html-email',
  //       body: jsonValue,
  //       headers: {
  //         "Accept": "application/json",
  //         "content-type": "application/json"
  //       });
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //   } else {
  //     throw "can't post";
  //   }
  // }

  // //APPOINTMENT-CANCELLED
  // Future appointmentCancelled(
  //     {String to,
  //     String name,
  //     String date,
  //     String time,
  //     String secondName}) async {
  //   ParameterMapCancelled parameterMap = ParameterMapCancelled(
  //     firstName: name,
  //     secondName: secondName,
  //     date: date,
  //     time: time,
  //     companyWebsiteLink: strings.companyWebsiteLink,
  //     companyName: strings.companyName,
  //   );
  //   AppointmentCancelled appointmentCancelled = AppointmentCancelled(
  //     from: strings.emailFrom,
  //     to: [to],
  //     html: true,
  //     template: true,
  //     templateName: "appointment-cancelled",
  //     subject: "Appointment Cancelled",
  //     parameterMap: parameterMap,
  //     staticResourceMap: StaticResourceMap(),
  //   );
  //   var jsonValue = jsonEncode(appointmentCancelled);
  //   Response response = await post('${strings.apiEndpoint}/send-html-email',
  //       body: jsonValue,
  //       headers: {
  //         "Accept": "application/json",
  //         "content-type": "application/json"
  //       });
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //   } else {
  //     throw "can't post";
  //   }
  // }

  // //APPOINTMENT-Booked
  // Future appointmentBooked(
  //     {String to,
  //     String name,
  //     String date,
  //     String time,
  //     String secondName}) async {
  //   ParameterMapCancelled parameterMap = ParameterMapCancelled(
  //     firstName: name,
  //     secondName: secondName,
  //     date: date,
  //     time: time,
  //     companyWebsiteLink: strings.companyWebsiteLink,
  //     companyName: strings.companyName,
  //   );
  //   AppointmentCancelled appointmentCancelled = AppointmentCancelled(
  //     from: strings.emailFrom,
  //     to: [to],
  //     html: true,
  //     template: true,
  //     templateName: "appointment-booked",
  //     subject: "Appointment Booked",
  //     parameterMap: parameterMap,
  //     staticResourceMap: StaticResourceMap(),
  //   );
  //   var jsonValue = jsonEncode(appointmentCancelled);
  //   Response response = await post('${strings.apiEndpoint}/send-html-email',
  //       body: jsonValue,
  //       headers: {
  //         "Accept": "application/json",
  //         "content-type": "application/json"
  //       });
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //   } else {
  //     throw "can't post";
  //   }
  // }

  //APPOINTMENT-status
  Future appointmentStatus(
      {String to,
      String name,
      String date,
      String time,
      String secondName,
      String status}) async {
    ParameterMapAppointment parameterMap = ParameterMapAppointment(
      firstName: name,
      secondName: secondName,
      date: date,
      time: time,
      status: status,
      companyWebsiteLink: strings.companyWebsiteLink,
      companyName: strings.companyName,
    );
    AppointmentStatus appointmentStatus = AppointmentStatus(
      from: strings.emailFrom,
      to: [to],
      html: true,
      template: true,
      templateName: "appointment-status",
      subject: "Easy App | Your Appointment #2 | $status",
      parameterMap: parameterMap,
      staticResourceMap: StaticResourceMap(),
    );
    var jsonValue = jsonEncode(appointmentStatus);
    Response response = await post('${strings.apiEndpoint}/send-html-email',
        body: jsonValue,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
    } else {
      throw "can't post";
    }
  }
}

class StaticResourceMap {
  StaticResourceMap();

  factory StaticResourceMap.fromJson(Map<String, dynamic> json) =>
      StaticResourceMap();

  Map<String, dynamic> toJson() => {};
}
