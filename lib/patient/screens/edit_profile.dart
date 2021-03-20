import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/profile_provider.dart';
import 'package:flutter_ea_mobile_app/models/patient_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/email_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_textfield.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  EditProfile(this.user);

  User user;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  PatientService patientService = PatientService();
  EmailService emailService = EmailService();
  CustomStrings customStrings = CustomStrings();
  CustomToast _toast = CustomToast();

  String name;
  String email;
  bool isLoading = false;

  //SIZES
  CustomSizes _sizes = CustomSizes();

  void toastPointer(PointerEvent details) {
    _toast.showDangerToast("Phone is not allowed to be edit");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: _colors.greyTheme,
                  borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 30,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Listener(
                    onPointerDown: toastPointer,
                    child: CustomTextField(
                      initialValue: widget.user.phone,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  CustomTextField(
                    initialValue: widget.user.fullName,
                    type: TextInputType.text,
                    hint: "Edit your name",
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z]+|\s')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  CustomTextField(
                    initialValue: widget.user.email,
                    hint: "Edit your email address",
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9@.]+|\s')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    type: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Consumer<ProfileProvider>(
                    builder: (context, patientProvider, child) => CustomButton(
                      color: _colors.green,
                      name: "Update",
                      pressed: () async {
                        bool isConnected =
                            await CheckInternet().isInternetConnected(context);
                        if (isConnected == true) {
                          setState(() {
                            isLoading = true;
                          });

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          int patientId = prefs.get("doctorId");
                          int userId = prefs.get("userId");

                          User _user = User(
                            id: widget.user.id,
                            fullName: name ?? widget.user.fullName,
                            email: email ?? widget.user.email,
                            type: widget.user.type,
                            landingUrl: widget.user.landingUrl,
                            phone: widget.user.phone,
                            gender: widget.user.gender,
                            username: widget.user.username,
                            password: widget.user.password,
                            avatar: widget.user.avatar,
                            state: widget.user.state,
                            status: widget.user.status,
                            createdDate: widget.user.createdDate,
                            updatedDate: widget.user.updatedDate,
//                    role: widget.user.role,
                          );

                          Patient patient = Patient(
                              id: patientId,
                              preference: null,
                              updatedDate: null,
                              user: _user);
                          await patientService.updatePatientProfile(
                              patient: patient);
                          patientProvider
                              .updateName(name ?? widget.user.fullName);
                          patientProvider
                              .updateEmail(email ?? widget.user.email);
                          setState(() {
                            isLoading = false;
                          });

                          await emailService.userProfileUpdated(
                            email ?? widget.user.email,
                            name ?? widget.user.fullName,
                          );
                          Navigator.pop(context);
                        } else {
                          _toast.showDangerToast(
                              "Please check your internet connection");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ),

          // For Loading
          isLoading
              ? Opacity(
                  opacity: 0.7,
                  child: Container(
                    height: 270.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: _colors.greyTheme),
                  ),
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
      ),
    );
  }
}
