import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/is_sign_in_or_sign_out.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/firebase_services/firebase_auth_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerification extends StatefulWidget {
  String verificationId;

  OtpVerification(this.verificationId);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  //Colors
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();
  CustomStrings _strings = CustomStrings();

  final _codeController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  CustomToast _toast = CustomToast();

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
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "We sent OTP code to verify your number",
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
                          PinCodeTextField(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            pastedTextStyle:
                                TextStyle(fontFamily: "CenturyGothic"),
                            appContext: context,
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            cursorHeight: 14.0,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              inactiveColor: _colors.grey,
                              activeColor: _colors.green,
                              selectedColor: _colors.green,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 40,
                              fieldWidth: 40,
                            ),
                            cursorColor: Colors.black,
                            animationDuration: Duration(milliseconds: 300),
                            textStyle: TextStyle(
                                fontSize: 14,
                                height: 1.0,
                                color: _colors.green,
                                fontWeight: FontWeight.w600,
                                fontFamily: "CenturyGothic"),
                            backgroundColor: _colors.greyTheme,
                            //enableActiveFill: true,
                            controller: _codeController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            keyboardType: TextInputType.number,
                            boxShadows: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: _colors.greyTheme,
                                blurRadius: 10,
                              )
                            ],
                            onChanged: (String value) {},
                          ),
                          SizedBox(
                            height: 15,
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
                                  prefs.setBool("login", true);

                                  //WITHOUT OTP START
                                  // dynamic user =
                                  //     await firebaseAuthService.signInAnon();

                                  // if (user == null) {
                                  //   throw "firebase User is null";
                                  // }
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             IsSignInOrSignOut()));
                                  //WITHOUT OTP END

                                  // WITH OTP START
                                  final code = _codeController.text.trim();
                                  print(code);
                                  AuthCredential credential =
                                      PhoneAuthProvider.getCredential(
                                          verificationId: widget.verificationId,
                                          smsCode: code);

                                  AuthResult result = await _auth
                                      .signInWithCredential(credential);

                                  FirebaseUser user = result.user;
                                  if (user != null) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IsSignInOrSignOut()));
                                  } else {
                                    throw "Error";
                                  }
                                  // WITH OTP END

                                } on Exception catch (exception) {
                                  print(exception);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  _toast
                                      .showDangerToast(_strings.exceptionText);
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
            )),
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
