import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/bottom_popups/appointment_status_confirmation.dart';
import 'package:flutter_ea_mobile_app/bottom_popups/custom_bottom_two_button_sheet.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/profile_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/main.dart';
import 'package:flutter_ea_mobile_app/models/patient_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';
import 'package:flutter_ea_mobile_app/patient/screens/edit_profile.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/email_service.dart';
import 'package:flutter_ea_mobile_app/services/firebase_services/firebase_auth_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_service.dart';
import 'package:flutter_ea_mobile_app/services/session_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button_small.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  PatientService patientService = PatientService();
  EmailService emailService = EmailService();
  CustomStrings customStrings = CustomStrings();
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  SessionService sessionService = SessionService();
  CustomToast _toast = CustomToast();

  bool toggleNote = true;
  bool toggleLoc = false;

  //SIZES
  CustomSizes _sizes = CustomSizes();

  Uint8List _bytesImage;
  File _image;
  String base64Image;
  bool isLoading = false;

  Future _openCamera(BuildContext context) async {
    var image2 = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    List<int> imageBytes = image2.readAsBytesSync();
    print(imageBytes);
    base64Image = base64Encode(imageBytes);
    print('string is');
    print(base64Image);
    print("You selected gallery image : " + image2.path);
  }

  Future _openGallery(BuildContext context) async {
    var image2 = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    List<int> imageBytes = image2.readAsBytesSync();
    print(imageBytes);
    base64Image = base64Encode(imageBytes);
    print('string is');
    print(base64Image);
    print("You selected gallery image : " + image2.path);
  }

  @override
  Widget build(BuildContext context) {
    void imagePicker(ProfileProvider prov) {
      showModalBottomSheet(
          context: context,
          enableDrag: false,
          isDismissible: false,
          builder: (BuildContext context) {
            return CustomBottomTwoButtonSheet(
              title1: "Camera",
              title2: "Gallery",
              titleColor1: _colors.grey,
              titleColor2: _colors.grey,
              onPressed1: () async {
                bool isConnected =
                    await CheckInternet().isInternetConnected(context);
                if (isConnected == true) {
                  _openCamera(context);
                } else {
                  _toast
                      .showDangerToast("Please check your internet connection");
                }
              },
              onPressed2: () async {
                bool isConnected =
                    await CheckInternet().isInternetConnected(context);
                if (isConnected == true) {
                  _openGallery(context);
                } else {
                  _toast
                      .showDangerToast("Please check your internet connection");
                }
              },
              onPressed3: () async {
                bool isConnected =
                    await CheckInternet().isInternetConnected(context);
                if (isConnected == true) {
                  //prov.updateAvatar(base64Image);

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  int patientId = prefs.get("doctorId");

                  User _user = User(
                    id: prov.user.id,
                    fullName: prov.user.fullName,
                    email: prov.user.email,
                    type: prov.user.type,
                    landingUrl: prov.user.landingUrl,
                    phone: prov.user.phone,
                    gender: prov.user.gender,
                    username: prov.user.username,
                    password: prov.user.password,
                    avatar: base64Image ?? prov.user.avatar,
                    state: prov.user.state,
                    status: prov.user.status,
                    createdDate: prov.user.createdDate,
                    updatedDate: prov.user.updatedDate,
//                  role: prov.user.role,
                  );

                  Patient patient = Patient(
                      id: patientId,
                      preference: null,
                      updatedDate: null,
                      user: _user);
                  print(patient);

                  await patientService.updatePatientProfile(patient: patient);
                  await emailService.userProfileUpdated(
                    prov.user.email,
                    prov.user.fullName,
                  );
                  Navigator.pop(context);
                } else {
                  _toast
                      .showDangerToast("Please check your internet connection");
                }
              },
            );
          });
    }

    return Scaffold(
      backgroundColor: _colors.greyTheme,
      appBar: CustomAppBar(
        title: "My Profile",
        notificationButton: false,
        logoutButton: false,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) => Stack(
          alignment: AlignmentDirectional.center,
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              bool isConnected = await CheckInternet()
                                  .isInternetConnected(context);
                              if (isConnected == true) {
                                imagePicker(profileProvider);
                              } else {
                                _toast.showDangerToast(
                                    "Please check your internet connection");
                              }
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 95.0,
                                  width: 95.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60.0),
                                      image: DecorationImage(
                                          image: (profileProvider.user == null
                                                      ? null
                                                      : profileProvider
                                                          .user.avatar) ==
                                                  null
                                              ? AssetImage("images/dp.png")
                                              : MemoryImage(Base64Decoder()
                                                  .convert(profileProvider
                                                      .user.avatar)),
                                          fit: BoxFit.fill)),
                                ),
                                Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: Icon(
                                    Icons.edit,
                                    color: _colors.green,
                                    size: 32,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                profileProvider.user == null
                                    ? ""
                                    : profileProvider.user.fullName ?? "",
                                style: TextStyle(
                                  color: _colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: _sizes.largeTextSize,
                                  fontFamily: "CenturyGothic",
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                profileProvider.user == null
                                    ? ""
                                    : profileProvider.user.email ?? "",
                                style: TextStyle(
                                  color: _colors.grey,
                                  fontSize: _sizes.smallTextSize,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "CenturyGothic",
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                profileProvider.user == null
                                    ? ""
                                    : profileProvider.user.phone ?? "",
                                style: TextStyle(
                                  color: _colors.grey,
                                  fontSize: _sizes.smallTextSize,
                                  fontFamily: "CenturyGothic",
                                ),
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              CustomButtonSmall(
                                name: " Edit ",
                                color: _colors.grey,
                                pressed: () async {
                                  bool isConnected = await CheckInternet()
                                      .isInternetConnected(context);
                                  if (isConnected == true) {
                                    showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return EditProfile(
                                              profileProvider.user);
                                        });
                                  } else {
                                    _toast.showDangerToast(
                                        "Please check your internet connection");
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      ),
                      // Container(
                      //     margin: EdgeInsets.only(left: 6.0),
                      //     child: Text(
                      //       "Notification",
                      //       style: TextStyle(
                      //         color: _colors.grey,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: _sizes.largeTextSize,
                      //         fontFamily: "CenturyGothic",
                      //       ),
                      //     )),
                      // SizedBox(
                      //   height: 15.0,
                      // ),
                      // NeuCard(
                      //     bevel: 9,
                      //     color: Color(0xFFECF0F3),
                      //     curveType: CurveType.flat,
                      //     decoration: NeumorphicDecoration(
                      //         color: _colors.greyTheme,
                      //         borderRadius: BorderRadius.circular(20)),
                      //     child: Padding(
                      //         padding: EdgeInsets.only(
                      //             top: 11, left: 20, right: 20, bottom: 10),
                      //         child: Column(
                      //           children: <Widget>[
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: <Widget>[
                      //                 Text(
                      //                   "App notifications",
                      //                   style: TextStyle(
                      //                     color: _colors.grey,
                      //                     fontSize: _sizes.smallTextSize,
                      //                     fontFamily: "CenturyGothic",
                      //                   ),
                      //                 ),
                      //                 Switch(
                      //                     activeColor: _colors.green,
                      //                     value: toggleNote,
                      //                     onChanged: (val) {
                      //                       setState(() {
                      //                         toggleNote = val;
                      //                       });
                      //                     })
                      //               ],
                      //             ),
                      //             Divider(
                      //               height: 10.0,
                      //               color: Colors.grey,
                      //             ),
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: <Widget>[
                      //                 Text(
                      //                   "Location tracking",
                      //                   style: TextStyle(
                      //                     color: _colors.grey,
                      //                     fontSize: _sizes.smallTextSize,
                      //                     fontFamily: "CenturyGothic",
                      //                   ),
                      //                 ),
                      //                 Switch(
                      //                     activeColor: _colors.green,
                      //                     value: toggleLoc,
                      //                     onChanged: (val) {
                      //                       setState(() {
                      //                         toggleLoc = val;
                      //                       });
                      //                     })
                      //               ],
                      //             ),
                      //           ],
                      //         ))),
                      SizedBox(
                        height: 40,
                      ),
                      Consumer5<
                          ProfileProvider,
                          LocationsProvider,
                          SchedulesProvider,
                          SlotsProvider,
                          AppointmentsProvider>(
                        builder: (context,
                                profileProvider,
                                locationsProvider,
                                schedulesProvider,
                                slotsProvider,
                                appointmentsProvider,
                                child) =>
                            Center(
                          child: CustomButton(
                            name: " Logout ",
                            color: _colors.green,
                            pressed: () async {
                              bool isConnected = await CheckInternet()
                                  .isInternetConnected(context);
                              if (isConnected == true) {
                                setState(() {
                                  isLoading = true;
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                await firebaseAuthService.signOut();

                                // DELETING SESSION
                                await sessionService
                                    .deleteSession(prefs.getInt("sessionId"));

                                // CLEARING SHARED_PREFERENCE
                                await prefs.clear();

                                profileProvider.user = null;
                                locationsProvider.locations = null;
                                schedulesProvider.finalSchedules = null;
                                slotsProvider.slots = null;
                                // appointmentsProvider
                                //     .patientScheduleAppointments = null;

                                Navigator.pushReplacement(
                                    context, // ROUTING
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()));
                              } else {
                                _toast.showDangerToast(
                                    "Please check your internet connection");
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
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
        ),
      ),
    );
  }
}
