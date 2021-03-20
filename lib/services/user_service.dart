import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointment_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/history_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/models/session_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/session_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  CustomStrings strings = CustomStrings();
  AppointmentService appointmentService = AppointmentService();
  PatientAppointmentService patientAppointmentService =
      PatientAppointmentService();
  SessionService sessionService = SessionService();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  // USER-LOGIN OR REGISTER
  Future<int> register(
      var phone,
      SchedulesProvider schedulesProvider,
      LocationsProvider locationsProvider,
      DoctorAppointmentsProvider doctorAppointmentsProvider,
      AppointmentListProvider appointmentListProvider,
      HistoryListProvider historyListProvider) async {
    print('phone: $phone');
    Response response = await get(
        '${strings.apiEndpoint}/login-or-register/$phone',
        headers: {"content-type": "application/json"});
    print("registerResponseStatusCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("registerResponseBody: ${response.body}");
      Map data = jsonDecode(response.body);
      print(data);

      int id = data["id"];
      int subId = data["subId"];
      String type = data["type"];
      String landingUrl = data["landingUrl"];
      int sessionId = data["session"]["id"];

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("userId", id);
      prefs.setInt("doctorId", subId);
      prefs.setString("type", type);
      prefs.setString("phone", phone);
      prefs.setString("landingUrl", landingUrl);
      prefs.setInt("sessionId", sessionId);

      int idValue = prefs.getInt("userId");
      int subIdValue = prefs.getInt("doctorId");
      String typeValue = prefs.getString("type");
      String landingUrlValue = prefs.getString("landingUrl");
      int sessionIdValue = prefs.getInt("sessionId");

      // SETTING DEVICE_TOKEN AND DEVICE_TYPE IN SESSION
      String fcmToken = await _fcm.getToken().then((value) => value);
      print("fcmTokenByRegister: $fcmToken");
      Session session =
          Session(deviceType: "smart-phone", deviceToken: fcmToken);
      await sessionService.updateSession(session, sessionIdValue);

      if (typeValue == "Doctor" && landingUrlValue == "Schedule") {
        // Not Used Anymore
        Doctor doctor = Doctor.fromJson(data["doctor"]);
        List<Location> locations = doctor.locations
            .map((location) => Location.fromJson(location))
            .toList();
        locationsProvider.locations = locations;
        print(
            "locationsProviderLocationsByRegister: ${locationsProvider.locations}");
      } else if (typeValue == "Doctor" &&
          landingUrlValue == "DoctorBottomNavigationBar") {
        Doctor doctor = Doctor.fromJson(data["doctor"]);
        List<Location> locations = doctor.locations
            .map((dynamic location) => Location.fromJson(location))
            .toList();
        locationsProvider.locations = locations;
        locations.forEach((location) {
          schedulesProvider.addSchedules(location.schedules
              .map((dynamic schedule) => Schedule.fromJson(schedule))
              .toList());
        });

        int doctorIdByPatientFlow; // doctorIdByPatientFlow is null Because this is doctor flow
        doctorAppointmentsProvider.doctorAppointments = await appointmentService
            .getAppointmentsByDoctorId(doctorIdByPatientFlow);

        print(
            "locationsProviderLocationsByRegister: ${locationsProvider.locations}");
        print(
            "schedulesProviderFinalSchedulesByRegister: ${schedulesProvider.finalSchedules}");
        print(
            "doctorAppointmentsByRegister: ${doctorAppointmentsProvider.doctorAppointments}");
      } else if (typeValue == "Patient") {
        List<Appointment> appointmentList =
            await patientAppointmentService.getAppointmentList();
        List<Appointment> historyList =
            await patientAppointmentService.getAppointmentHistoryList();

        appointmentListProvider.appointments = appointmentList;
        historyListProvider.appointments = historyList;
        print(
            "appointmentListProviderAppointmentsByRegister: ${appointmentListProvider.appointments}");
        print(
            "historyListProviderAppointmentsByRegister: ${historyListProvider.appointments}");
      }

      print('userId: $idValue');
      print('subId: $subIdValue');
      print('type: $typeValue');
      print('landingUrl: $landingUrlValue');
      print('sessionId: $sessionIdValue');

      return id;
    } else {
      throw "can't get";
    }
  }

  // USER-TYPE SELECTOR
  Future typeSelector(String userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.get("userId");
    print('userId: $id');
    User _user = User(id: id, type: userType, state: true);
    var userJson = jsonEncode(_user);

    Response response = await put('${strings.apiEndpoint}/user/type/$id',
        body: userJson,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map data = jsonDecode(response.body);
      int doctorId = data["id"];
      prefs.setInt("doctorId", doctorId);

      print('Body: ${response.body}');
      print('doctorId: $doctorId');
    } else {
      throw "can't get";
    }
  }

  // GET a User
  Future<User> getAUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.get("userId");
    Response response = await get('${strings.apiEndpoint}/user/$id',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map body = jsonDecode(response.body);
      User user = User.fromJson(body);
      print(user);
      return user;
    } else {
      throw "can't get";
    }
  }

  //Update landingUrlValue
  Future updateLandingUrl({String landingUrl}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.get("userId");
    User _user = User(
        id: userId,
//      updatedDate: DateTime.now(),
        landingUrl: landingUrl);
    var userJson = jsonEncode(_user);
    Response response = await put(
        '${strings.apiEndpoint}/user/landing-url/$userId',
        body: userJson,
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
    } else {
      throw "can't get";
    }
  }
}
