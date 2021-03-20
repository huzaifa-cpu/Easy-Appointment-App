import 'dart:convert';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/doctor/doctor_bottom_tabs/doctor_bottom_navigation_bar.dart';
import 'package:flutter_ea_mobile_app/doctor/widgets/schedule_card.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/doctor_service.dart';
import 'package:flutter_ea_mobile_app/services/location_service.dart';
import 'package:flutter_ea_mobile_app/services/schedule_service.dart';
import 'package:flutter_ea_mobile_app/services/user_service.dart';
import 'package:flutter_ea_mobile_app/services/utils_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_textfield.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateLocationAndScheduleScreen extends StatefulWidget {
  String appBarTitle;
  String submitButtonName;
  bool isClinicTab;
  bool backButton;
  VoidCallback backButtonPressed;
  int index;

  CreateLocationAndScheduleScreen(
      {this.appBarTitle,
      this.submitButtonName,
      this.backButtonPressed,
      this.isClinicTab,
      this.index,
      this.backButton});

  @override
  _CreateLocationAndScheduleScreenState createState() =>
      _CreateLocationAndScheduleScreenState();
}

class _CreateLocationAndScheduleScreenState
    extends State<CreateLocationAndScheduleScreen> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  CustomStrings _strings = CustomStrings();

  LocationService locationService = LocationService();
  ScheduleService scheduleService = ScheduleService();
  UserService userService = UserService();
  DoctorService doctorService = DoctorService();
  CustomToast _toast = CustomToast();
  Utils utils = Utils();
  CustomSizes _sizes = CustomSizes();

  final _formKey = GlobalKey<FormState>();
  String name;
  String address;
  int fee = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Consumer2<LocationsProvider, SchedulesProvider>(
          builder: (context, locationsProvider, schedulesProvider, child) =>
              Scaffold(
                  backgroundColor: _colors.greyTheme,
                  appBar: CustomAppBar(
                    title: widget.appBarTitle,
                    notificationButton: false,
                    backButtonPressed: widget.backButtonPressed,
                    notificationButtonPressed: () {},
                    logoutButton: widget.isClinicTab ? false : true,
                  ),
                  body: Container(
                      child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        initialValue: "",
                        hint: "Enter clinic name",
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z]+|\s')),
                        ],
                        type: TextInputType.name,
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        initialValue: "",
                        hint: "Enter clinic address",
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9-/,#&]+|\s')),
                        ],
                        type: TextInputType.text,
                        onChanged: (val) {
                          setState(() {
                            address = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        initialValue: "",
                        hint: "Enter consultancy fee",
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        type: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            fee = int.parse(val);
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Weekly Schedules",
                        style: TextStyle(
                          fontFamily: "CenturyGothic",
                          color: _colors.grey,
                          fontSize: _sizes.titleTextSize,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: schedulesProvider.schedules.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: ScheduleCard(
                                schedule: schedulesProvider.schedules[index],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomButton(
                        color: _colors.green,
                        name: widget.submitButtonName,
                        pressed: () async {
                          bool isConnected = await CheckInternet()
                              .isInternetConnected(context);
                          if (isConnected == true) {
                            if (name != null &&
                                address != null &&
                                fee != 0 &&
                                fee != null) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                Doctor doctor = await doctorService.getDoctor();

                                Location location = Location(
                                    createdDate: utils.getCurrentDate(),
                                    name: name,
                                    address: address,
                                    fee: fee,
                                    state: true,
                                    status: "Active",
                                    doctor: doctor);

                                var locationJson = jsonEncode(location);
                                print(locationJson);
                                Location locationFromResponse =
                                    await locationService
                                        .createLocation(locationJson);
                                locationsProvider
                                    .addLocation(locationFromResponse);

                                schedulesProvider
                                    .setNullPkAndCreatedDateOfSchedules();
                                schedulesProvider
                                    .setLocation(locationFromResponse);
                                List<Schedule> schedules =
                                    schedulesProvider.schedules;
                                print("schedules: $schedules");
                                var scheduleListJson = jsonEncode(schedules);
                                print("scheduleListJson: $scheduleListJson");
                                List<Schedule> schedulesFromApi =
                                    List<Schedule>();
                                schedulesFromApi = await scheduleService
                                    .createSchedule(scheduleListJson);
                                print("schedulesFromApi: $schedulesFromApi");

                                schedulesProvider
                                    .addSchedules(schedulesFromApi);
                                print(
                                    "schedulesProvider.finalSchedules: ${schedulesProvider.finalSchedules}");

                                await userService.updateLandingUrl(
                                    landingUrl: "DoctorBottomNavigationBar");
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    "landingUrl", "DoctorBottomNavigationBar");

                                if (widget.isClinicTab) {
                                  Navigator.pop(context);
                                }

                                Navigator.pushReplacement(
                                    context, // ROUTING
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorBottomNavigationBar(
                                              location: locationFromResponse,
                                              appoints:
                                                  widget.isClinicTab ?? true
                                                      ? false
                                                      : true,
                                              clinics:
                                                  widget.isClinicTab ?? true
                                                      ? true
                                                      : false,
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
                              _toast.showToast("Data may invalid or empty");
                            }
                          } else {
                            _toast.showDangerToast(
                                "Please check your internet connection");
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ))),
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
