import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/create_location_and_schedule_activity.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/doctor_service.dart';
import 'package:flutter_ea_mobile_app/services/user_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_textfield.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_location_activity.dart';

class PmdcVerification extends StatefulWidget {
  @override
  _PmdcVerificationState createState() => _PmdcVerificationState();
}

class _PmdcVerificationState extends State<PmdcVerification> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  CustomToast _toast = CustomToast();
  CustomStrings _strings = CustomStrings();

  UserService userService = UserService();
  DoctorService doctorService = DoctorService();

  var pmdcNo;
  final _formKey = GlobalKey<FormState>();
  TextEditingController pmdcRegistrationNumberController =
      TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Scaffold(
          backgroundColor: _colors.greyTheme,
          appBar: CustomAppBar(
            title: "PMDC Verification",
            notificationButton: false,
            backButtonPressed: () {},
            notificationButtonPressed: () {},
            logoutButton: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              textEditingController:
                                  pmdcRegistrationNumberController,
                              hint: "Enter PMDC Registration Number",
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9]')),
                              ],
                              type: TextInputType.text,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              color: _colors.green,
                              name: "Verify",
                              pressed: () async {
                                bool isConnected = await CheckInternet()
                                    .isInternetConnected(context);
                                if (isConnected == true) {
                                  if (pmdcRegistrationNumberController
                                      .text.isNotEmpty) {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await doctorService.verifyDoctorByPmdcNo(
                                          pmdcRegistrationNumberController
                                              .text);
                                      await userService.updateLandingUrl(
                                          landingUrl: "CreateClinic");
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          "landingUrl", "CreateClinic");
                                      Navigator.pushReplacement(
                                          context, // ROUTING
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateLocationAndScheduleScreen(
                                                    appBarTitle:
                                                        "Create Clinic",
                                                    submitButtonName: "Create",
                                                    backButton: false,
                                                    isClinicTab: false,
                                                    backButtonPressed: () {},
                                                  )));
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
                                      _toast
                                          .showDangerToast(_strings.errorText);
                                    }
                                  } else {
                                    _toast
                                        .showToast("PMDC may empty or invalid");
                                  }
                                } else {
                                  _toast.showDangerToast(
                                      "Please check your internet connection");
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
