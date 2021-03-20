import 'dart:convert';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/doctor_service.dart';
import 'package:flutter_ea_mobile_app/services/location_service.dart';
import 'package:flutter_ea_mobile_app/services/user_service.dart';
import 'package:flutter_ea_mobile_app/services/utils_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_textfield.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_schedule_screen.dart';

class CreateLocationScreen extends StatefulWidget {
  Location location;
  bool isSchedule;
  bool isEdit;
  String appBarTitle;
  String submitButtonName;
  bool isClinicTab;
  bool backButton;
  VoidCallback backButtonPressed;
  int index;

  CreateLocationScreen(
      {this.appBarTitle,
      this.location,
      this.submitButtonName,
      this.backButtonPressed,
      this.isSchedule,
      this.isClinicTab,
      this.index,
      this.isEdit,
      this.backButton});

  @override
  _CreateLocationScreenState createState() => _CreateLocationScreenState();
}

class _CreateLocationScreenState extends State<CreateLocationScreen> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  CustomStrings _strings = CustomStrings();

  LocationService locationService = LocationService();
  UserService userService = UserService();
  DoctorService doctorService = DoctorService();
  CustomToast _toast = CustomToast();
  Utils utils = Utils();

  final _formKey = GlobalKey<FormState>();
  String name = '';
  String address = '';
  TextEditingController fee;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fee = TextEditingController(text: widget.location.fee.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Scaffold(
            backgroundColor: _colors.greyTheme,
            appBar: CustomAppBar(
              title: widget.appBarTitle,
              notificationButton: false,
              backButtonPressed: widget.backButtonPressed,
              notificationButtonPressed: () {},
              logoutButton: widget.isClinicTab
                  ? false
                  : widget.isEdit
                      ? false
                      : true,
            ),
            body: Container(
                child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          initialValue:
                              widget.isEdit ? widget.location.name : "",
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
//                          textEditingController: name,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          initialValue:
                              widget.isEdit ? widget.location.address : "",
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
//                          textEditingController: address,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
//                          initialValue: widget.isEdit
//                              ? widget.location.fee.toString()
//                              : "",
                          hint: "Enter consultancy fee",
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          type: TextInputType.number,
//                          onChanged: (val) {
//                            setState(() {
//                              fee = int.parse(val);
//                            });
//                          },
                          textEditingController: fee,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Consumer<LocationsProvider>(
                            builder: (context, locationsProvider, child) =>
                                CustomButton(
                                  color: _colors.green,
                                  name: widget.submitButtonName,
                                  pressed: () async {
                                    bool isConnected = await CheckInternet()
                                        .isInternetConnected(context);
                                    if (isConnected == true) {
                                      if (name != null &&
                                          address != null &&
                                          int.parse(fee.text) != 0 &&
                                          fee.text != null) {
                                        try {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Doctor doctor =
                                              await doctorService.getDoctor();
                                          if (widget.isSchedule) {
                                            await userService.updateLandingUrl(
                                                landingUrl: "Schedule");
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                                "landingUrl", "Schedule");

                                            Location location = Location(
                                                createdDate:
                                                    utils.getCurrentDate(),
                                                name: name,
                                                address: address,
                                                fee: int.parse(fee.text),
                                                state: true,
                                                status: "Active",
                                                doctor: doctor);

                                            var locationJson =
                                                jsonEncode(location);
                                            print(locationJson);
                                            Location locationFromResponse =
                                                await locationService
                                                    .createLocation(
                                                        locationJson);
                                            locationsProvider.addLocation(
                                                locationFromResponse);

                                            Navigator.pushReplacement(
                                                context, // ROUTING
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateScheduleScreen(
                                                          isSchedule:
                                                              widget.isSchedule,
                                                          location:
                                                              locationFromResponse,
                                                        )));
                                          } else if (widget.isEdit) {
                                            print(
                                                "name: ${name}, address: ${address},fee: $fee.text");
                                            Location locations = Location(
                                                updatedDate:
                                                    utils.getCurrentDate(),
                                                name: name == ""
                                                    ? widget.location.name
                                                    : name,
                                                address: address == ""
                                                    ? widget.location.address
                                                    : address,
                                                fee: int.parse(fee.text) == 0
                                                    ? widget.location.fee
                                                    : int.parse(fee.text),
                                                state: true,
                                                status: "Active",
                                                doctor: widget.location.doctor);
                                            var locationJson =
                                                jsonEncode(locations);
                                            print(locationJson);
                                            Location locationFromApi =
                                                await locationService
                                                    .updateLocation(
                                                        locationJson,
                                                        widget.location.id);
                                            locationsProvider.updateLocation(
                                                locationFromApi);

                                            Navigator.pop(context);
                                          } else if (widget.isClinicTab) {
                                            Location location = Location(
                                                createdDate:
                                                    utils.getCurrentDate(),
                                                name: name,
                                                address: address,
                                                fee: int.parse(fee.text),
                                                state: true,
                                                status: "Active",
                                                doctor: doctor);

                                            var locationJson =
                                                jsonEncode(location);
                                            print(locationJson);
                                            Location locationFromResponse =
                                                await locationService
                                                    .createLocation(
                                                        locationJson);
                                            locationsProvider.addLocation(
                                                locationFromResponse);

                                            Navigator.pushReplacement(
                                                context, // ROUTING
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateScheduleScreen(
                                                          isSchedule:
                                                              widget.isSchedule,
                                                          location:
                                                              locationFromResponse,
                                                        )));
                                          }
                                        } on Exception catch (exception) {
                                          print(exception);
                                          setState(() {
                                            isLoading = false;
                                          });
                                          _toast.showDangerToast(
                                              _strings.exceptionText);
                                        } catch (error) {
                                          print(error);
                                          setState(() {
                                            isLoading = false;
                                          });
                                          _toast.showDangerToast(
                                              _strings.errorText);
                                        }
                                      } else {
                                        _toast.showToast(
                                            "Data may invalid or empty");
                                      }
                                    } else {
                                      _toast.showDangerToast(
                                          "Please check your internet connection");
                                    }
                                  },
                                )),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))),
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
