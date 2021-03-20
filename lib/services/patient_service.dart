import 'dart:convert';

import 'package:flutter_ea_mobile_app/models/patient_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientService {
  CustomStrings strings = CustomStrings();

  // UPDATE patient profile
  Future updatePatientProfile({var patient}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int patientId = prefs.get("doctorId");
    int userId = prefs.get("userId");
    print('patientId: $patientId');
    print('userId: $userId');
    var patientJson = jsonEncode(patient);
    print(patientJson);
    Response response = await put(
        '${strings.apiEndpoint}/patient-profile/$patientId',
        body: patientJson,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
    } else {
      throw "can't update";
    }
  }

  // getOrCreatePatient ~when doctor creates appointment
  Future<Patient> getOrCreatePatient(String phone) async {
    Response response = await get(
        '${strings.apiEndpoint}/get-or-create-patient/$phone',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map body = jsonDecode(response.body);
      Patient patient = Patient.fromJson(body);
      print("getOrCreatePatient: $patient");
      return patient;
    } else {
      throw "can't get";
    }
  }

  // getPatientById
  Future<Patient> getPatientById(int patientId) async {
    Response response = await get(
        '${strings.apiEndpoint}/patient/$patientId',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map body = jsonDecode(response.body);
      Patient patient = Patient.fromJson(body);
      print("getPatientById: $patient");
      return patient;
    } else {
      throw "can't get";
    }
  }
}
