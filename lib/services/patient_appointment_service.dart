import 'dart:convert';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientAppointmentService {
  CustomStrings strings = CustomStrings();
  //GET - Patient Appointment list
  Future<List<Appointment>> getAppointmentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("phone");
    print(phone);
    Response response = await get(
        '${strings.apiEndpoint}/patient-appointments/${phone}',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print(body);
      List<Appointment> appointments =
          body.map((dynamic item) => Appointment.fromJson(item)).toList();
      print(appointments);
      return appointments;
    } else {
      throw "Can't get appointments";
    }
  }

  //GET - Patient Appointment History list
  Future<List<Appointment>> getAppointmentHistoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("phone");
    print(phone);
    Response response = await get(
        '${strings.apiEndpoint}/patient-appointments-history/${phone}',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print(body);
      List<Appointment> appointmentsHistory =
          body.map((dynamic item) => Appointment.fromJson(item)).toList();
      print(appointmentsHistory);
      return appointmentsHistory;
    } else {
      throw "Can't get appointmentsHistory";
    }
  }
}
