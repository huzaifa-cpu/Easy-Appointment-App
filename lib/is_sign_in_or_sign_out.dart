import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/create_location_and_schedule_activity.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/verify_doctor_activity.dart';
import 'package:flutter_ea_mobile_app/login_activity.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/patient/mainPage.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/firebase_services/fcm_service.dart';
import 'package:flutter_ea_mobile_app/services/firebase_services/firebase_auth_service.dart';
import 'package:flutter_ea_mobile_app/services/location_service.dart';
import 'package:flutter_ea_mobile_app/services/schedule_service.dart';
import 'package:flutter_ea_mobile_app/user_type_selector.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_notifier_providers/doctor_appointments_provider.dart';
import 'change_notifier_providers/slots_provider.dart';
import 'doctor/doctor_bottom_tabs/doctor_bottom_navigation_bar.dart';
import 'doctor/screens/create_location_activity.dart';
import 'doctor/screens/create_schedule_screen.dart';
import 'doctor/screens/verify_doctor_activity.dart';
import 'models/appointment_model.dart';

class IsSignInOrSignOut extends StatefulWidget {
  @override
  _IsSignInOrSignOutState createState() => _IsSignInOrSignOutState();
}

class _IsSignInOrSignOutState extends State<IsSignInOrSignOut> {
  CustomThemeColors _colors = CustomThemeColors();

  LocationService locationService = LocationService();

  ScheduleService scheduleService = ScheduleService();

  AppointmentService appointmentService = AppointmentService();

  int doctorIdByPatientFlow;

  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FcmService fcmService = FcmService();

  int localNotificationChannelId = 0;

  int setLocalNotificationChannelId() {
    setState(() {
      localNotificationChannelId += 1;
    });
    print("localNotificationChannelId: $localNotificationChannelId");
    return localNotificationChannelId;
  }

  @override
  void initState() {
    super.initState();
    // PROVIDERS
    SlotsProvider slotsProvider =
    Provider.of<SlotsProvider>(context, listen: false);
    DoctorAppointmentsProvider doctorAppointmentsProvider =
    Provider.of<DoctorAppointmentsProvider>(context, listen: false);

    // FCM
    fcmService.initializeFcmServices(
        doctorAppointmentsProvider: doctorAppointmentsProvider,
        slotsProvider: slotsProvider,
        setLocalNotificationChannelId: setLocalNotificationChannelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.greyTheme,
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              String landingUrl = (snapshot.data.getString("landingUrl")) ?? '';
              String type = (snapshot.data.getString("type")) ?? '';
              bool login = (snapshot.data.getBool("login")) ?? false;
              print('landingUrl: $landingUrl, type: $type, login: $login');
              // either LoginPage or LoggedInUrl
              if (login == false) {
                print("new user");
                return LoginPage();
              } else {
                print("old user");
                if (type == '') {
                  return UserTypeSelector();
                } else if (type == "Patient") {
                  return MainPage();
                } else if (type == "Doctor" &&
                    landingUrl != "CreateClinic" &&
                    landingUrl != "Schedule" &&
                    landingUrl != "DoctorBottomNavigationBar") {
                  return PmdcVerification();
                } else if (type == "Doctor" && landingUrl == "CreateClinic") {
                  return CreateLocationAndScheduleScreen(
                    appBarTitle: "Create Clinic",
                    submitButtonName: "Create",
                    isClinicTab: false,
                    backButton: false,
                    backButtonPressed: () {},
                  );
                } else if (type == "Doctor" && landingUrl == "Schedule") {
                  // Not Used anymore
                  return FutureBuilder(
                      future: locationService.getListOfLocationsByPhone(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          List<Location> locations = snapshot.data[0];
                          return CreateScheduleScreen(
                            location: locations[0],
                          );
                        }
                        return CustomLoading();
                      });
                } else if (type == "Doctor" &&
                    landingUrl == "DoctorBottomNavigationBar") {
                  return FutureBuilder(
                      future: Future.wait([
                        locationService.getListOfLocationsByPhone(),
                        scheduleService.getListOfSchedulesByPhone(),
                        appointmentService
                            .getAppointmentsByDoctorId(doctorIdByPatientFlow)
                      ]),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          List<Location> locations = snapshot.data[0];
                          List<Schedule> schedules = snapshot.data[1];
                          List<Appointment> appointments = snapshot.data[2];
                          return DoctorBottomNavigationBar(
                            appointmentsFromApi: appointments,
                            locationsFromApi: locations,
                            schedulesFromApi: schedules,
                            location: locations[0],
                            appoints: true,
                            clinics: false,
                            profiles: false,
                            schedule: false,
                          );
                        }
                        return CustomLoading();
                      });
                }
              }
            }
            return CustomLoading();
          }),
    );
  }
}
