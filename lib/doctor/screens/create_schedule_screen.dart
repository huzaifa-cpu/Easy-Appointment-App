import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/doctor/doctor_bottom_tabs/doctor_bottom_navigation_bar.dart';
import 'package:flutter_ea_mobile_app/doctor/widgets/schedule_card.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/schedule_service.dart';
import 'package:flutter_ea_mobile_app/services/user_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateScheduleScreen extends StatefulWidget {
  Location location;
  bool isSchedule;

  CreateScheduleScreen({this.location, this.isSchedule});

  @override
  _CreateScheduleScreenState createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  CustomThemeColors _colors = CustomThemeColors();
  CustomStrings _strings = CustomStrings();
  CustomSizes _sizes = CustomSizes();

  ScheduleService scheduleService = ScheduleService();

  UserService userService = UserService();

  CustomToast _toast = CustomToast();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Scaffold(
          backgroundColor: _colors.greyTheme,
          appBar: CustomAppBar(
            title: "Create Schedule",
            backButtonPressed: () {},
            notificationButton: false,
            notificationButtonPressed: () {},
            logoutButton: widget.isSchedule ?? true,
          ),
          body: Consumer<SchedulesProvider>(
            builder: (context, schedulesProvider, child) => Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Day",
                            style: TextStyle(
                              color: _colors.grey,
                              fontSize: _sizes.xsTextSize,
                              fontFamily: "CenturyGothic",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Start",
                            style: TextStyle(
                              color: _colors.grey,
                              fontSize: _sizes.xsTextSize,
                              fontFamily: "CenturyGothic",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "End",
                            style: TextStyle(
                              color: _colors.grey,
                              fontSize: _sizes.xsTextSize,
                              fontFamily: "CenturyGothic",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Slot",
                            style: TextStyle(
                              color: _colors.grey,
                              fontSize: _sizes.xsTextSize,
                              fontFamily: "CenturyGothic",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Holiday",
                            style: TextStyle(
                              color: _colors.grey,
                              fontSize: _sizes.xsTextSize,
                              fontFamily: "CenturyGothic",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: schedulesProvider.schedules.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: ScheduleCard(
                            schedule: schedulesProvider.schedules[index],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomButton(
                    name: "Create",
                    color: _colors.green,
                    pressed: () async {
                      bool isConnected =
                          await CheckInternet().isInternetConnected(context);
                      if (isConnected == true) {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          await userService.updateLandingUrl(
                              landingUrl: "DoctorBottomNavigationBar");
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              "landingUrl", "DoctorBottomNavigationBar");
                          schedulesProvider
                              .setNullPkAndCreatedDateOfSchedules();
                          schedulesProvider.setLocation(widget.location);
                          List<Schedule> schedules =
                              schedulesProvider.schedules;
                          print("schedules: $schedules");
                          var scheduleListJson = jsonEncode(schedules);
                          print("scheduleListJson: $scheduleListJson");
                          List<Schedule> schedulesFromApi = List<Schedule>();
                          schedulesFromApi = await scheduleService
                                  .createSchedule(scheduleListJson);
                          print("schedulesFromApi: $schedulesFromApi");

                          schedulesProvider.addSchedules(schedulesFromApi);
                          print(
                              "schedulesProvider.finalSchedules: ${schedulesProvider.finalSchedules}");
                          if (widget.isSchedule == false) {
                            Navigator.pop(context);
                          }
                          Navigator.pushReplacement(
                              context, // ROUTING
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DoctorBottomNavigationBar(
                                        location: widget.location,
                                        appoints: widget.isSchedule ?? true
                                            ? true
                                            : false,
                                        clinics: widget.isSchedule ?? true
                                            ? false
                                            : true,
                                        profiles: false,
                                        schedule: false,
                                      )));
                        } on Exception catch (exception) {
                          print(exception);
                          setState(() {
                            isLoading = false;
                          });
                          _toast.showDangerToast(_strings.exceptionText);
                        } catch (error) {
                          print(error);
                          setState(() {
                            isLoading = false;
                          });
                          _toast.showDangerToast(_strings.errorText);
                        }
                      } else {
                        _toast.showDangerToast(
                            "Please check your internet connection");
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        // For Loading
        isLoading
            ? Opacity(
                opacity: 0.7,
                child: Scaffold(backgroundColor: _colors.greyTheme),
              )
            : SizedBox(
                height: 0.0,
              ),
        isLoading
            ? CustomLoading()
            : SizedBox(
                height: 0.0,
              ),
      ],
    );
  }
}
