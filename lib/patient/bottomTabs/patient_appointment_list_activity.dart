import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/notifications_screen.dart';
import 'package:flutter_ea_mobile_app/patient/screens/patient_schedule_appointment.dart';
import 'package:flutter_ea_mobile_app/patient/screens/patient_schedule_history.dart.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';

class PatientAppointmentList extends StatefulWidget {
  @override
  _PatientAppointmentListState createState() => _PatientAppointmentListState();
}

class _PatientAppointmentListState extends State<PatientAppointmentList> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();
  CustomToast _toast = CustomToast();

  final pages = [PatientScheduleAppointment(), PatientScheduleHistory()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: _colors.greyTheme,
          appBar: AppBar(
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: _colors.grey,
                    ),
                    onPressed: () async {
                      bool isConnected =
                          await CheckInternet().isInternetConnected(context);
                      if (isConnected == true) {
                        Navigator.push(
                            context, // ROUTING
                            MaterialPageRoute(
                                builder: (context) => NotificationsScreen()));
                      } else {
                        _toast.showDangerToast(
                            "Please check your internet connection");
                      }
                    },
                  ),
                  SizedBox(
                    width: 5.0,
                  )
                ],
              ),
            ],
            centerTitle: true,
            backgroundColor: _colors.greyTheme,
            elevation: 0.0,
            title: Text(
              "My Appointments",
              style: TextStyle(
                color: _colors.grey,
                fontSize: _sizes.titleTextSize,
                fontWeight: FontWeight.w900,
                fontFamily: "CenturyGothic",
              ),
            ),
            bottom: TabBar(
              indicatorColor: _colors.green,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    "Schedule",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _sizes.smallTextSize,
                      color: _colors.grey,
                      fontFamily: "CenturyGothic",
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "History",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _sizes.smallTextSize,
                      color: _colors.grey,
                      fontFamily: "CenturyGothic",
                    ),
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(children: pages)),
    );
  }
}
