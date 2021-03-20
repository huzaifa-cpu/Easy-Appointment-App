import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointment_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/history_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/is_sign_in_or_sign_out.dart';
import 'package:flutter_ea_mobile_app/otp_activity.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/user_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_textfield.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

import 'change_notifier_providers/schedules_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();
  CustomToast _toast = CustomToast();
  CustomStrings _strings = CustomStrings();

  final _phoneController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  UserService userService = UserService();
  bool isLoading = false;

  Future<bool> loginUser(String phone, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => IsSignInOrSignOut()));
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          Navigator.pushReplacement(
              context, // ROUTING
              MaterialPageRoute(
                  builder: (context) => OtpVerification(verificationId)));
        },
        codeAutoRetrievalTimeout: null);
  }

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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 130),
                            child: Text(
                              "Login/Register via Phone",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _sizes.smallTextSize,
                                  color: _colors.grey,
                                  fontFamily: "CenturyGothic"),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          CustomTextField(
                            hint: "Enter 11-digits phone eg.03222222222",
                            type: TextInputType.phone,
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            textEditingController: _phoneController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Consumer5<
                              LocationsProvider,
                              SchedulesProvider,
                              DoctorAppointmentsProvider,
                              AppointmentListProvider,
                              HistoryListProvider>(
                            builder: (context,
                                    locationsProvider,
                                    schedulesProvider,
                                    doctorAppointmentsProvider,
                                    appointmentListProvider,
                                    historyListProvider,
                                    child) =>
                                CustomButton(
                              color: _colors.green,
                              name: "Continue",
                              pressed: () async {
                                bool isConnected = await CheckInternet()
                                    .isInternetConnected(context);
                                if (isConnected == true) {
                                  // WITHOUT OTP START
                                  // if (_formKey.currentState.validate()) {
                                  //   try {
                                  //     setState(() {
                                  //       isLoading = true;
                                  //     });
                                  //     final phone =
                                  //         _phoneController.text.trim();
                                  //     await userService.register(
                                  //         phone,
                                  //         schedulesProvider,
                                  //         locationsProvider,
                                  //         doctorAppointmentsProvider,
                                  //         appointmentListProvider,
                                  //         historyListProvider);
                                  //     Navigator.pushReplacement(
                                  //         context, // ROUTING
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 OtpVerification("")));
                                  //   } on Exception catch (exception) {
                                  //     print(exception);
                                  //     setState(() {
                                  //       isLoading = false;
                                  //     });
                                  //     _toast.showDangerToast(
                                  //         _strings.exceptionText);
                                  //   } catch (error) {
                                  //     print(error);
                                  //     setState(() {
                                  //       isLoading = false;
                                  //     });
                                  //     _toast
                                  //         .showDangerToast(_strings.errorText);
                                  //   }
                                  // }
                                  // WITHOUT OTP END

                                  //WITH OTP START
                                  if (_phoneController.text.isNotEmpty &&
                                      _phoneController.text.length > 10 &&
                                      _phoneController.text.length < 12) {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      String phoneWithCountryCode =
                                          "+92${_phoneController.text.substring(1, 11)}";
                                      final phone = phoneWithCountryCode.trim();
                                      await loginUser(phone, context);
                                      await userService.register(
                                          phone,
                                          schedulesProvider,
                                          locationsProvider,
                                          doctorAppointmentsProvider,
                                          appointmentListProvider,
                                          historyListProvider);
                                    } on Exception catch (exception) {
                                      _toast.showDangerToast(
                                          _strings.exceptionText);
                                    } catch (error) {
                                      _toast
                                          .showDangerToast(_strings.errorText);
                                    }
                                  } else {
                                    _toast.showToast(
                                        "Phone may empty or invalid");
                                  }
                                  //WITH OTP END
                                } else {
                                  _toast.showDangerToast(
                                      "Please check your internet connection");
                                }
                              },
                            ),
                          )
                        ],
                      ),
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
