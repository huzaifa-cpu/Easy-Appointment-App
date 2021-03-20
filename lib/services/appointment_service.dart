import 'dart:convert';

import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentService {
  CustomStrings strings = CustomStrings();

  Future<Appointment> createAppointment(Appointment appointment) async {
    var appointmentJson = json.encode(appointment);
    Response response = await post('${strings.apiEndpoint}/appointment',
        body: appointmentJson,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      Appointment appointment = Appointment.fromJson(data);
      return appointment;
    } else {
      throw "can't create appointment";
    }
  }

  //GET DOCTOR-APPOINTMENT-LIST-BY-PHONE-LOCATIONID-SLOTDATE
  Future<List<Appointment>>
      getDoctorAppointmentListByPhoneLocationIdAndSlotDate(
          String phone, int locationId, DateTime slotDate) async {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(slotDate);
    Response response = await get(
        '${strings.apiEndpoint}/doctor-appointments/$phone/$locationId/$formattedDate',
        headers: {"content-type": "application/json"});
    print("getDoctorAppointmentListResponseStatusCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print("getDoctorAppointmentListByPhoneLocationIdAndSlotDate: $body");
      if (body.length != 0) {
        List<Appointment> appointments =
            body.map((dynamic item) => Appointment.fromJson(item)).toList();
        return appointments ?? [];
      }
      return [];
//      print(appointments);

    } else {
      throw "Can't get posts";
    }
  }

  Future<Appointment> updateAppointmentStatus(
      Appointment appointment, int appointmentId) async {
    var appointmentJson = json.encode(appointment);
    Response response = await put(
        '${strings.apiEndpoint}/appointment/status/$appointmentId',
        body: appointmentJson,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      print("updatedAppointmentStatusFromResponse: $data");
      Appointment appointment = Appointment.fromJson(data);
      return appointment;
    } else {
      throw "can't update appointment status";
    }
  }

  //GET DOCTOR-APPOINTMENT-LIST-BY-PHONE-LOCATIONID-SLOTDATE
  Future<List<Appointment>> getAppointmentsByDoctorId(
      int doctorIdByPatientFlow) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int doctorIdByDoctorFlow = prefs.getInt("doctorId");
    int doctorId = doctorIdByPatientFlow ?? doctorIdByDoctorFlow;
    Response response = await get(
        '${strings.apiEndpoint}/appointments/doctor/$doctorId',
        headers: {"content-type": "application/json"});
    print("getDoctorAppointmentListResponseStatusCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print("getDoctorAppointmentListByPhoneLocationIdAndSlotDate: $body");
      if (body.length != 0) {
        List<Appointment> appointments =
            body.map((dynamic item) => Appointment.fromJson(item)).toList();
        return appointments ?? [];
      }
      return [];
    } else {
      throw "Can't get posts";
    }
  }

  Future<Appointment> getAppointmentById(int appointmentId) async {
    Response response = await get(
        '${strings.apiEndpoint}/appointment/$appointmentId',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      print("getAppointmentById: $data");
      Appointment appointment = Appointment.fromJson(data);
      return appointment;
    } else {
      throw "can't update appointment status";
    }
  }
}
