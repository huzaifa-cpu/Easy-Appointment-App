import 'dart:convert';

import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorService {
  CustomStrings strings = CustomStrings();

  //VERIFY-PMDC
  Future verifyDoctorByPmdcNo(var pmdcNo) async {
    print(pmdcNo);
    Response responseFromPmdc = await get(
        '${strings.apiEndpoint}/verify-doctor/${pmdcNo}',
        headers: {"content-type": "application/json"});
    print(responseFromPmdc.statusCode);

    if (responseFromPmdc.statusCode == 200) {
      Map body = jsonDecode(responseFromPmdc.body);
      Map doctorFromJson = body['data'][0];
      print('doctor: ${doctorFromJson}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int doctorId = prefs.get("doctorId");
      int userId = prefs.get("userId");
      Doctor doctorFromModel = Doctor(
        id: doctorId,
        registrationNo: doctorFromJson['RegistrationNo'],
        fatherName: doctorFromJson['FatherName'],
        registrationType: doctorFromJson['RegistrationType'],
        registrationDate: doctorFromJson['RegistrationDate'],
        validUpto: doctorFromJson['ValidUpto'],
        qualifications: doctorFromJson['Qualifications'],
        locations: null,
        user: User(
          id: userId,
          fullName: doctorFromJson['Name'],
          gender: doctorFromJson['Gender'],
        ),
      );
      print(doctorFromModel.toJson());
      print('doctorId: $doctorId, userId: $userId');
      var doctorToJson = jsonEncode(doctorFromModel);
      Response responseFromUpdateDoctor = await put(
          '${strings.apiEndpoint}/doctor-profile/$doctorId',
          body: doctorToJson,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      print(responseFromUpdateDoctor.statusCode);
      if (responseFromUpdateDoctor.statusCode == 200) {
        print(responseFromUpdateDoctor.body);
      } else {
        throw "Network error";
      }
    } else {
      throw "network error";
    }
  }

  //GET DOCTOR-LIST
  Future<List<Doctor>> getDoctorList() async {
    Response response = await get('${strings.apiEndpoint}/doctors',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print(body);
      List<Doctor> doctors =
          body.map((dynamic item) => Doctor.fromJson(item)).toList();
      print(doctors);
      return doctors;
    } else {
      throw "Can't get posts";
    }
  }

  //GET DOCTOR
  Future<Doctor> getDoctor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int doctorId = prefs.get("doctorId");
    Response response = await get('${strings.apiEndpoint}/doctor/${doctorId}',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      Doctor doctors = Doctor.fromJson(body);
      print(doctors);
      return doctors;
    } else {
      throw "Can't get Doctors";
    }
  }

  // UPDATE doctor profile
  Future updateDoctorProfile(var doctor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int doctorId = prefs.get("doctorId");
    int userId = prefs.get("userId");
    print('patientId: $doctorId');
    print('userId: $userId');
    var doctorJson = jsonEncode(doctor);
    print(doctorJson);
    Response response = await put(
        '${strings.apiEndpoint}/doctor-profile/${doctorId}',
        body: doctorJson,
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
}
