import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/notifications_screen.dart';
import 'package:flutter_ea_mobile_app/doctor/widgets/schedule_card.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/patient/screens/doctor_schedule_location_selector.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/schedule_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_location_dropdown.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class DoctorScheduleTab extends StatefulWidget {
  DoctorScheduleTab({this.location});

  Location location;

  //COLORS
  @override
  _DoctorScheduleTabState createState() => _DoctorScheduleTabState();
}

class _DoctorScheduleTabState extends State<DoctorScheduleTab> {
  List<Schedule> schedulesByLocationId;

  // COLORS
  CustomThemeColors _colors = CustomThemeColors();

  // SIZES
  CustomSizes _sizes = CustomSizes();

  // TOAST
  CustomToast _toast = CustomToast();

  ScheduleService scheduleService = ScheduleService();

  void onClinicLocation() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return DoctorScheduleLocationSelector();
        });
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    SchedulesProvider schedulesProvider =
        Provider.of<SchedulesProvider>(context, listen: false);
    schedulesByLocationId =
        schedulesProvider.getSchedulesByLocationId(widget.location.id);
    if (schedulesByLocationId.length != 0) {
      schedulesProvider.setSchedules(schedulesByLocationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Scaffold(
          backgroundColor: _colors.greyTheme,
          appBar: CustomAppBar(
            title: "Schedules",
            backButtonPressed: () {},
            notificationButton: true,
            notificationButtonPressed: () async {
              bool isConnected =
                  await CheckInternet().isInternetConnected(context);
              if (isConnected == true) {
                Navigator.push(
                    context, // ROUTING
                    MaterialPageRoute(
                        builder: (context) => NotificationsScreen()));
              } else {
                _toast.showDangerToast("Please check your internet connection");
              }
            },
            logoutButton: false,
          ),
          body: Consumer2<SchedulesProvider, LocationsProvider>(
            builder: (context, schedulesProvider, locationsProvider, child) =>
                Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  CustomLocationDropDown(
                    locationName:
                        locationsProvider.getLocationName(widget.location),
                    pressed: () async {
                      bool isConnected =
                          await CheckInternet().isInternetConnected(context);
                      if (isConnected == true) {
                        onClinicLocation();
                      } else {
                        _toast.showDangerToast(
                            "Please check your internet connection");
                      }
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
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
                        return ScheduleCard(
                          schedule: schedulesProvider.schedules[index],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomButton(
                    name:
                        schedulesByLocationId.length != 0 ? "Update" : "Create",
                    color: _colors.green,
                    pressed: () async {
                      bool isConnected =
                          await CheckInternet().isInternetConnected(context);
                      if (isConnected == true) {
                        setState(() {
                          isLoading = true;
                        });
                        var schedules = schedulesProvider.schedules;
                        var scheduleListJson = jsonEncode(schedules);
                        print(scheduleListJson);
                        List<Schedule> updatedSchedules =
                            await scheduleService.updateSchedule(
                                scheduleListJson, widget.location.id);
                        print("updatedSchedule: $updatedSchedules");
                        schedulesProvider.updateSchedules(updatedSchedules);
                        setState(() {
                          isLoading = false;
                        });
                        _toast.showToast("Schedule Updated");
                      } else {
                        _toast.showDangerToast(
                            "Please check your internet connection");
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.0,
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
