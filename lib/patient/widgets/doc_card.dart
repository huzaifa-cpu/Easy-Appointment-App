import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/patient/screens/patient_location_selector.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatefulWidget {
  DoctorCard({this.doctor, this.enableLoading, this.disableLoading});

  Doctor doctor;
  Function enableLoading;
  Function disableLoading;

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();
  CustomToast _toast = CustomToast();

  AppointmentService appointmentService = AppointmentService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 17,
        ),
        NeuCard(
          margin: EdgeInsets.only(left: 16, right: 16),
          bevel: 9,
          curveType: CurveType.flat,
          decoration: NeumorphicDecoration(
              color: _colors.greyTheme,
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.only(top: 11, left: 10, right: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                NeuCard(
                  curveType: CurveType.flat,
                  bevel: 12,
                  decoration: NeumorphicDecoration(
                      color: _colors.greyTheme,
                      borderRadius: BorderRadius.circular(40)),
                  child: Container(
                    height: 75.0,
                    width: 75.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        image: DecorationImage(
                            image: widget.doctor.user.avatar == null
                                ? AssetImage("images/dp.png")
                                : MemoryImage(Base64Decoder()
                                    .convert(widget.doctor.user.avatar)),
                            fit: BoxFit.fill)),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.doctor.titlesStr ?? "No Titles",
                      style: TextStyle(
                        color: _colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                    Text(
                      widget.doctor.user.fullName,
                      style: TextStyle(
                        fontSize: _sizes.largeTextSize,
                        color: _colors.grey,
                        fontWeight: FontWeight.bold,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                    Text(
                      widget.doctor.degreesStr ?? "No Degrees",
                      style: TextStyle(
                        fontSize: 12,
                        color: _colors.grey,
                        fontWeight: FontWeight.bold,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                    SizedBox(height: 15),
                    Consumer3<LocationsProvider, SchedulesProvider,
                        DoctorAppointmentsProvider>(
                      builder: (context, locationsProvider, schedulesProvider,
                              doctorAppointmentsProvider, child) =>
                          GestureDetector(
                        // BOOK NOW
                        onTap: () async {
                          bool isConnected = await CheckInternet()
                              .isInternetConnected(context);
                          if (isConnected == true) {
                            widget.enableLoading();
                            List<Location> locations = widget.doctor.locations
                                .map((dynamic item) => Location.fromJson(item))
                                .toList();
                            locationsProvider.locations = locations;

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
                            schedulesProvider.finalSchedules = schedules;

                            doctorAppointmentsProvider.doctorAppointments =
                                await appointmentService
                                    .getAppointmentsByDoctorId(
                                        widget.doctor.id);

                            print(
                                "schedulesProviderFinalSchedulesFromDocCard: ${schedulesProvider.finalSchedules}");

                            print(
                                "locationsProviderLocationsFromDocCard: ${locationsProvider.locations}");

                            print(
                                "doctorAppointmentsFromDocCard: ${doctorAppointmentsProvider.doctorAppointments}");
                            widget.disableLoading();
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return PatientLocationSelector(
                                    isBookNow: true,
                                  );
                                });
                          } else {
                            _toast.showDangerToast(
                                "Please check your internet connection");
                          }
                        },
                        child: NeuCard(
                            alignment: Alignment.center,
                            bevel: 9,
                            curveType: CurveType.flat,
                            height: 25.0,
                            width: 85.0,
                            decoration: NeumorphicDecoration(
                                color: _colors.greyTheme,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.calendar_today,
                                    size: 12, color: _colors.grey),
                                Text(
                                  " Book Now ",
                                  style: TextStyle(
                                    color: _colors.grey,
                                    fontSize: 10.0,
                                    fontFamily: "CenturyGothic",
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
