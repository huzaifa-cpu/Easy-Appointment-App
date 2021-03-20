import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointment_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/history_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/profile_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
// import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';
import 'package:flutter_ea_mobile_app/patient/bottomTabs/doctor_list_activity.dart';
import 'package:flutter_ea_mobile_app/patient/bottomTabs/patient_appointment_list_activity.dart';
import 'package:flutter_ea_mobile_app/patient/bottomTabs/patient_profile_activity.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/user_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_square_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //
  bool doctor = true;
  bool appoints = false;
  bool profiles = false;

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  UserService userService = UserService();
  PatientAppointmentService patientAppointmentService =
      PatientAppointmentService();
  CustomToast _toast = CustomToast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.greyTheme,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: _colors.greyTheme,
        child: Consumer5<ProfileProvider, DoctorAppointmentsProvider,
            SlotsProvider, SchedulesProvider, LocationsProvider>(
          builder: (context, patientProvider, doctorAppointmentsProvider,
                  slotsProvider, schedulesProvider, locationsProvider, child) =>
              FutureBuilder(
                  future: Future.wait([
                    userService.getAUser(),
                    patientAppointmentService.getAppointmentList(),
                    patientAppointmentService.getAppointmentHistoryList()
                  ]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      //API HIT
                      User user = snapshot.data[0];
                      List<Appointment> currentAppointment = snapshot.data[1];
                      List<Appointment> historyAppointment = snapshot.data[2];

                      //PROVIDERS SET
                      patientProvider.user = user;

                      return Consumer2<AppointmentListProvider,
                          HistoryListProvider>(
                        builder: (context, appointmentListProvider,
                                historyListProvider, child) =>
                            Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CustomSquareButton(
                                      icon: Icons.person_add,
                                      color:
                                          doctor ? _colors.green : _colors.grey,
                                      pressed: () async {
                                        bool isConnected = await CheckInternet()
                                            .isInternetConnected(context);
                                        if (isConnected == true) {
                                          // setting null to all doctor providers
                                          schedulesProvider
                                              .setEmptyFinalSchedules();
                                          print(
                                              "finalSchedulesFromDoctorListTab: ${schedulesProvider.finalSchedules}");

                                          slotsProvider.setEmptySlots();
                                          print(
                                              "slotsFromDoctorListTab: ${slotsProvider.slots}");

                                          doctorAppointmentsProvider
                                              .setEmptyDoctorAppointments();
                                          print(
                                              "doctorAppointmentsFromDoctorListTab: ${doctorAppointmentsProvider.doctorAppointments}");

                                          locationsProvider.setEmptyLocations();
                                          print(
                                              "locationsFromDoctorListTab: ${locationsProvider.locations}");

                                          setState(() {
                                            doctor = true;
                                            appoints = false;
                                            profiles = false;
                                          });
                                        } else {
                                          _toast.showDangerToast(
                                              "Please check your internet connection");
                                        }
                                      },
                                    ),
                                    CustomSquareButton(
                                      icon: Icons.playlist_add_check,
                                      color: appoints
                                          ? _colors.green
                                          : _colors.grey,
                                      pressed: () async {
                                        bool isConnected = await CheckInternet()
                                            .isInternetConnected(context);
                                        if (isConnected == true) {
                                          setState(() {
                                            appointmentListProvider
                                                    .appointments =
                                                currentAppointment;
                                            historyListProvider.appointments =
                                                historyAppointment;
                                            doctor = false;
                                            appoints = true;
                                            profiles = false;
                                          });
                                        } else {
                                          _toast.showDangerToast(
                                              "Please check your internet connection");
                                        }
                                      },
                                    ),
                                    CustomSquareButton(
                                      icon: Icons.person_pin,
                                      color: profiles
                                          ? _colors.green
                                          : _colors.grey,
                                      pressed: () async {
                                        bool isConnected = await CheckInternet()
                                            .isInternetConnected(context);
                                        if (isConnected == true) {
                                          setState(() {
                                            patientProvider.user = user;
                                            doctor = false;
                                            appoints = false;
                                            profiles = true;
                                          });
                                        } else {
                                          _toast.showDangerToast(
                                              "Please check your internet connection");
                                        }
                                      },
                                    ),
                                  ],
                                )),
                      );
                    } else {
                      return CustomLoading();
                    }
                  }),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(
            alignment: Alignment.center,
            child: doctor
                ? Doctor()
                : appoints
                    ? PatientAppointmentList()
                    : Profile()),
      ),
    );
  }
}
