import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/verify_doctor_activity.dart';
import 'package:flutter_ea_mobile_app/patient/mainPage.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/user_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:selectable_container/selectable_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTypeSelector extends StatefulWidget {
  @override
  _UserTypeSelectorState createState() => _UserTypeSelectorState();
}

class _UserTypeSelectorState extends State<UserTypeSelector> {
  //Colors
  CustomThemeColors _colors = CustomThemeColors();
  CustomToast _toast = CustomToast();
  CustomStrings _strings = CustomStrings();

  UserService userService = UserService();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  bool doctorSelect = true;
  bool patientSelect = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Scaffold(
          backgroundColor: _colors.greyTheme,
          resizeToAvoidBottomInset: false,
          body: ListView(
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 60.0,
                    ),
                    //LOGO IMAGE
                    Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/one.png"))),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    //TEXT
                    Column(
                      children: <Widget>[
                        Text(
                          "Which one are you",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _sizes.smallTextSize,
                            color: _colors.grey,
                            fontFamily: "CenturyGothic",
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // DCOTOR SELECTOR
                            SelectableContainer(
                              borderRadius: 120,
                              selectedBorderColor: _colors.green,
                              selectedBackgroundColor: Colors.grey.shade100,
                              unselectedBorderColor: _colors.grey,
                              unselectedBackgroundColor: Colors.grey.shade200,
                              iconAlignment: Alignment.topRight,
                              icon: Icons.check,
                              iconColor: Colors.white,
                              iconSize: 20,
                              unselectedOpacity: 0.5,
                              selected: doctorSelect,
                              //padding: 8.0,
                              onPressed: () {
                                setState(() {
                                  doctorSelect = true;
                                  patientSelect = false;
                                });
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          //grey
                                          color: Color(0xFFD1D9E6),
                                          offset: Offset(5.0, 5.0),
                                          blurRadius: 2.0,
                                          spreadRadius: 4.0),
                                      BoxShadow(
                                          //white
                                          color: Color(0xFFFFFFFF),
                                          offset: Offset(-5.0, -5.0),
                                          blurRadius: 3.0,
                                          spreadRadius: 3.0),
                                    ],
                                    borderRadius: BorderRadius.circular(80),
                                    border: Border.all(
                                        width: 4, color: Color(0xFF39927B)),
                                    image: DecorationImage(
                                        image:
                                            AssetImage("images/doctor.png"))),
                              ),
                            ),

                            // PATIENT SELECTOR
                            SelectableContainer(
                              borderRadius: 80,
                              selectedBorderColor: _colors.green,
                              selectedBackgroundColor: Colors.grey.shade100,
                              unselectedBorderColor: _colors.grey,
                              unselectedBackgroundColor: Colors.grey.shade200,
                              iconAlignment: Alignment.topRight,
                              icon: Icons.check,
                              iconColor: Colors.white,
                              iconSize: 20,
                              unselectedOpacity: 0.5,
                              selected: patientSelect,
                              //padding: 0.0,
                              onPressed: () {
                                setState(() {
                                  patientSelect = true;
                                  doctorSelect = false;
                                });
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          //grey
                                          color: Color(0xFFD1D9E6),
                                          offset: Offset(5.0, 5.0),
                                          blurRadius: 2.0,
                                          spreadRadius: 4.0),
                                      BoxShadow(
                                          //white
                                          color: Color(0xFFFFFFFF),
                                          offset: Offset(-5.0, -5.0),
                                          blurRadius: 3.0,
                                          spreadRadius: 3.0),
                                    ],
                                    borderRadius: BorderRadius.circular(120),
                                    border: Border.all(
                                        width: 4, color: Color(0xFF39927B)),
                                    image: DecorationImage(
                                        image:
                                            AssetImage("images/patient.png"))),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              width: 0,
                            ),
                            Text(
                              "Doctor",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _sizes.smallTextSize,
                                color: Color(0xFF39927B),
                                fontFamily: "CenturyGothic",
                              ),
                            ),
                            SizedBox(
                              width: 35,
                            ),
                            Text(
                              "Patient",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _sizes.smallTextSize,
                                color: Color(0xFF39927B),
                                fontFamily: "CenturyGothic",
                              ),
                            ),
                            SizedBox(
                              width: 0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        CustomButton(
                          color: _colors.green,
                          name: "Continue",
                          pressed: () async {
                            bool isConnected = await CheckInternet()
                                .isInternetConnected(context);
                            if (isConnected == true) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (patientSelect) {
                                  await userService.typeSelector("Patient");
                                  prefs.setString("type", "Patient");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPage()));
                                } else if (doctorSelect) {
                                  await userService.typeSelector("Doctor");
                                  prefs.setString("type", "Doctor");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PmdcVerification()));
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  _toast.showToast("Please select any of two");
                                }
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
                      ],
                    )
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
