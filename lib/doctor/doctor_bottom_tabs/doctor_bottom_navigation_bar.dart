import "package:flutter/material.dart";
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/profile_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/doctor/doctor_bottom_tabs/doctor_appointment_list_tab.dart';
import 'package:flutter_ea_mobile_app/doctor/doctor_bottom_tabs/doctor_location_tab.dart';
import 'package:flutter_ea_mobile_app/doctor/doctor_bottom_tabs/doctor_profile_tab.dart';
import 'package:flutter_ea_mobile_app/doctor/doctor_bottom_tabs/doctor_schedule_tab.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/doctor_service.dart';
import 'package:flutter_ea_mobile_app/services/location_service.dart';
import 'package:flutter_ea_mobile_app/services/schedule_service.dart';
import 'package:flutter_ea_mobile_app/services/user_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

class DoctorBottomNavigationBar extends StatefulWidget {
  Location location;
  bool clinics;
  bool appoints;
  bool profiles;
  bool schedule;
  List<Schedule> schedulesFromApi;
  List<Location> locationsFromApi;
  List<Appointment> appointmentsFromApi;

  DoctorBottomNavigationBar(
      {this.location,
      this.clinics,
      this.appoints,
      this.profiles,
      this.schedule,
      this.schedulesFromApi,
      this.locationsFromApi,
      this.appointmentsFromApi});

  @override
  _DoctorBottomNavigationBarState createState() =>
      _DoctorBottomNavigationBarState();
}

class _DoctorBottomNavigationBarState extends State<DoctorBottomNavigationBar> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  UserService userService = UserService();
  DoctorService doctorService = DoctorService();
  LocationService locationService = LocationService();
  ScheduleService scheduleService = ScheduleService();
  AppointmentService appointmentService = AppointmentService();

  //SIZES
  CustomSizes _sizes = CustomSizes();
  CustomToast _toast = CustomToast();
  int doctorIdByPatientFlow;

  @override
  void initState() {
    super.initState();

    SchedulesProvider schedulesProvider =
        Provider.of<SchedulesProvider>(context, listen: false);
    if (widget.schedulesFromApi != null &&
        widget.schedulesFromApi.length != 0) {
      schedulesProvider.finalSchedules = widget.schedulesFromApi;
    }

    LocationsProvider locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);
    if (widget.locationsFromApi != null &&
        widget.locationsFromApi.length != 0) {
      locationsProvider.locations = widget.locationsFromApi;
    }

    DoctorAppointmentsProvider doctorAppointmentsProvider =
        Provider.of<DoctorAppointmentsProvider>(context, listen: false);
    if (widget.appointmentsFromApi != null) {
      doctorAppointmentsProvider.doctorAppointments =
          widget.appointmentsFromApi;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.greyTheme,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: _colors.greyTheme,
        child: Container(
            padding: EdgeInsets.all(8),
            child: Consumer5<DoctorProvider, ProfileProvider, LocationsProvider,
                SchedulesProvider, DoctorAppointmentsProvider>(
              builder: (context,
                      doctorProvider,
                      profileProvider,
                      locationsProvider,
                      schedulesProvider,
                      doctorAppointmentsProvider,
                      child) =>
                  FutureBuilder(
                      future: Future.wait([
                        doctorService.getDoctor(),
//                        appointmentService
//                            .getAppointmentsByDoctorId(doctorIdByPatientFlow)
                        // doctorIdByPatientFlow is null Because this is doctor flow
                      ]),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          Doctor doctor = snapshot.data[0];
                          doctorProvider.doctor = doctor;
                          profileProvider.user = doctor.user;

                          // SETTING LOCATIONS_PROVIDER
                          List<Location> locations = doctor.locations
                              .map((location) => Location.fromJson(location))
                              .toList();
                          locationsProvider.locations = locations;
                          print(
                              "locationsProviderLocationsByDoctorBottomNavigationBar: ${locationsProvider.locations}");

                          // SETTING SCHEDULES_PROVIDER
//                          List<Schedule> schedules = [];
//                          locations.forEach((location) {
//                            if (location.schedules.length != 0) {
//                              schedules.addAll(location.schedules
//                                  .map((dynamic schedule) =>
//                                      Schedule.fromJson(schedule))
//                                  .toList());
//                            }
//                          });
//                          schedulesProvider.finalSchedules = schedules;

                          print(
                              "schedulesProviderFinalSchedulesByDoctorBottomNavigationBar: ${schedulesProvider.finalSchedules}");

                          // SETTING DOCTOR_APPOINTMENTS_PROVIDER
//                          doctorAppointmentsProvider.doctorAppointments =
//                              snapshot.data[1];

                          print(
                              "doctorAppointmentsByDoctorBottomNavigationBar: ${doctorAppointmentsProvider.doctorAppointments}");

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: _sizes.squareButtonSize,
                                height: _sizes.squareButtonSize,
                                child: NeuButton(
                                  decoration: NeumorphicDecoration(
                                      color: _colors.greyTheme,
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () async {
                                    bool isConnected = await CheckInternet()
                                        .isInternetConnected(context);
                                    if (isConnected == true) {
                                      // SETTING SCHEDULES_PROVIDER
                                      List<Schedule> schedules = [];
                                      locations.forEach((location) {
                                        if (location.schedules.length != 0) {
                                          schedules.addAll(location.schedules
                                              .map((dynamic schedule) =>
                                                  Schedule.fromJson(schedule))
                                              .toList());
                                        }
                                      });
                                      schedulesProvider.finalSchedules =
                                          schedules;
                                      setState(() {
                                        widget.clinics = false;
                                        widget.appoints = true;
                                        widget.profiles = false;
                                        widget.schedule = false;
                                      });
                                    } else {
                                      _toast.showDangerToast(
                                          "Please check your internet connection");
                                    }
                                  },
                                  child: Icon(
                                    Icons.playlist_add_check,
                                    color: widget.appoints
                                        ? _colors.green
                                        : _colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                width: _sizes.squareButtonSize,
                                height: _sizes.squareButtonSize,
                                child: NeuButton(
                                  decoration: NeumorphicDecoration(
                                      color: _colors.greyTheme,
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () async {
                                    bool isConnected = await CheckInternet()
                                        .isInternetConnected(context);
                                    if (isConnected == true) {
                                      // SETTING SCHEDULES_PROVIDER
                                      List<Schedule> schedules = [];
                                      locations.forEach((location) {
                                        if (location.schedules.length != 0) {
                                          schedules.addAll(location.schedules
                                              .map((dynamic schedule) =>
                                                  Schedule.fromJson(schedule))
                                              .toList());
                                        }
                                      });
                                      schedulesProvider.finalSchedules =
                                          schedules;
                                      setState(() {
                                        widget.clinics = true;
                                        widget.appoints = false;
                                        widget.profiles = false;
                                        widget.schedule = false;
                                      });
                                    } else {
                                      _toast.showDangerToast(
                                          "Please check your internet connection");
                                    }
                                  },
                                  child: Icon(
                                    Icons.local_hospital,
                                    color: widget.clinics
                                        ? _colors.green
                                        : _colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                width: _sizes.squareButtonSize,
                                height: _sizes.squareButtonSize,
                                child: NeuButton(
                                  decoration: NeumorphicDecoration(
                                      color: _colors.greyTheme,
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () async {
                                    bool isConnected = await CheckInternet()
                                        .isInternetConnected(context);
                                    if (isConnected == true) {
                                      // SETTING SCHEDULES_PROVIDER
                                      List<Schedule> schedules = [];
                                      locations.forEach((location) {
                                        if (location.schedules.length != 0) {
                                          schedules.addAll(location.schedules
                                              .map((dynamic schedule) =>
                                                  Schedule.fromJson(schedule))
                                              .toList());
                                        }
                                      });
                                      schedulesProvider.finalSchedules =
                                          schedules;
                                      setState(() {
                                        widget.clinics = false;
                                        widget.appoints = false;
                                        widget.profiles = false;
                                        widget.schedule = true;
                                      });
                                    } else {
                                      _toast.showDangerToast(
                                          "Please check your internet connection");
                                    }
                                  },
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: widget.schedule
                                        ? _colors.green
                                        : _colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                width: _sizes.squareButtonSize,
                                height: _sizes.squareButtonSize,
                                child: NeuButton(
                                  decoration: NeumorphicDecoration(
                                      color: _colors.greyTheme,
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () async {
                                    bool isConnected = await CheckInternet()
                                        .isInternetConnected(context);
                                    if (isConnected == true) {
                                      // SETTING SCHEDULES_PROVIDER
                                      List<Schedule> schedules = [];
                                      locations.forEach((location) {
                                        if (location.schedules.length != 0) {
                                          schedules.addAll(location.schedules
                                              .map((dynamic schedule) =>
                                                  Schedule.fromJson(schedule))
                                              .toList());
                                        }
                                      });
                                      schedulesProvider.finalSchedules =
                                          schedules;
                                      setState(() {
                                        doctorProvider.doctor = doctor;
                                        profileProvider.user = doctor.user;
                                        widget.clinics = false;
                                        widget.appoints = false;
                                        widget.profiles = true;
                                        widget.schedule = false;
                                      });
                                    } else {
                                      _toast.showDangerToast(
                                          "Please check your internet connection");
                                    }
                                  },
                                  child: Icon(
                                    Icons.person_pin,
                                    color: widget.profiles
                                        ? _colors.green
                                        : _colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return CustomLoading();
                      }),
            )),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Consumer<LocationsProvider>(
          builder: (context, locationsProvider, child) => Container(
              alignment: Alignment.center,
              child: widget.clinics
                  ? LocationsTab()
                  : widget.appoints
                      ? AppointmentsTab(
                          location: widget.location == null
                              ? locationsProvider.locations[0]
                              : widget.location,
                        )
                      : widget.profiles
                          ? ProfileTab()
                          : widget.schedule
                              ? DoctorScheduleTab(
                                  location: widget.location == null
                                      ? locationsProvider.locations[0]
                                      : widget.location,
                                )
                              : Container()),
        ),
      ),
    );
  }
}
