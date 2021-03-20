import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/profile_provider.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';
import 'package:flutter_ea_mobile_app/services/doctor_service.dart';
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

class EditDoctor extends StatefulWidget {
  Doctor doctor;
  User user;
  EditDoctor(this.doctor, this.user);
  @override
  _EditDoctorState createState() => _EditDoctorState();
}

class _EditDoctorState extends State<EditDoctor> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  PatientService patientService = PatientService();
  EmailService emailService = EmailService();
  CustomStrings customStrings = CustomStrings();
  CustomToast _toast = CustomToast();
  DoctorService doctorService = DoctorService();

  String name;
  String email;
  bool isLoading = false;

  //SIZES
  CustomSizes _sizes = CustomSizes();

  void nameToastPointer(PointerEvent details) {
    _toast.showToast("Name is not allowed to be edit");
  }

  void phoneToastPointer(PointerEvent details) {
    _toast.showToast("Phone is not allowed to be edit");
  }

  void pmdcToastPointer(PointerEvent details) {
    _toast.showToast("PMDC is not allowed to be edit");
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
                    onPointerDown: nameToastPointer,
                    child: CustomTextField(
                      initialValue: widget.user.fullName,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Listener(
                    onPointerDown: pmdcToastPointer,
                    child: CustomTextField(
                      initialValue: widget.doctor.registrationNo,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Listener(
                    onPointerDown: phoneToastPointer,
                    child: CustomTextField(
                      initialValue: widget.user.phone,
                      readOnly: true,
                    ),
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
                  Consumer2<DoctorProvider, ProfileProvider>(
                    builder:
                        (context, doctorProvider, profileProvider, child) =>
                            CustomButton(
                      color: _colors.green,
                      name: "Update",
                      pressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        User _user = User(
                          id: widget.user.id,
                          fullName: widget.user.fullName,
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
                        );

                        Doctor doctorObj = Doctor(
                          id: widget.doctor.id,
                          registrationNo: widget.doctor.registrationNo,
                          fatherName: widget.doctor.fatherName,
                          registrationDate: widget.doctor.registrationDate,
                          registrationType: widget.doctor.registrationType,
                          validUpto: widget.doctor.validUpto,
                          qualifications: widget.doctor.qualifications,
                          titlesStr: widget.doctor.titlesStr,
                          degreesStr: widget.doctor.degreesStr,
                          titles: widget.doctor.titles,
                          degrees: widget.doctor.degrees,
                          practiceStartingDate:
                              widget.doctor.practiceStartingDate,
                          description: widget.doctor.description,
                          createdDate: widget.doctor.createdDate,
                          updatedDate: widget.doctor.updatedDate,
                          user: _user,
                          locations: widget.doctor.locations,
                        );

                        print(doctorObj);
                        await doctorService.updateDoctorProfile(doctorObj);
                        profileProvider.updateEmail(email);

                        setState(() {
                          isLoading = false;
                        });

                        //EMAIL
                        await emailService.userProfileUpdated(
                          email ?? profileProvider.user.email,
                          profileProvider.user.fullName,
                        );
                        Navigator.pop(context);
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
