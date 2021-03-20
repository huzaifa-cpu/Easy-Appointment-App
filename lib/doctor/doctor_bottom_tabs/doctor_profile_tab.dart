import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/bottom_popups/appointment_status_confirmation.dart';
import 'package:flutter_ea_mobile_app/bottom_popups/custom_bottom_sheet_with_textfiled_and_submitbutton.dart';
import 'package:flutter_ea_mobile_app/bottom_popups/custom_bottom_two_button_sheet.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/profile_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/main.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/doctor_service.dart';
import 'package:flutter_ea_mobile_app/services/email_service.dart';
import 'package:flutter_ea_mobile_app/services/firebase_services/firebase_auth_service.dart';
import 'package:flutter_ea_mobile_app/services/session_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button_small.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  //CHECKBOXES BOOLS

  bool dentist = true;
  bool physician = true;

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  String email;

  //SIZES
  CustomSizes _sizes = CustomSizes();
  DoctorService doctorService = DoctorService();
  EmailService emailService = EmailService();
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  SessionService sessionService = SessionService();

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

  CustomToast _toast = CustomToast();

  @override
  Widget build(BuildContext context) {
    void imagePicker(Doctor doc, ProfileProvider profileProvider) {
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
                  await profileProvider.updateAvatar(base64Image);

                  User _user = User(
                    id: profileProvider.user.id,
                    fullName: profileProvider.user.fullName,
                    email: profileProvider.user.email,
                    type: profileProvider.user.type,
                    landingUrl: profileProvider.user.landingUrl,
                    phone: profileProvider.user.phone,
                    gender: profileProvider.user.gender,
                    username: profileProvider.user.username,
                    password: profileProvider.user.password,
                    avatar: base64Image ?? profileProvider.user.avatar,
                    state: profileProvider.user.state,
                    status: profileProvider.user.status,
                    createdDate: profileProvider.user.createdDate,
                    updatedDate: profileProvider.user.updatedDate,
//                  role: profileProvider.user.role,
                  );

                  Doctor doctorObj = Doctor(
                    id: doc.id,
                    registrationNo: doc.registrationNo,
                    fatherName: doc.fatherName,
                    registrationDate: doc.registrationDate,
                    registrationType: doc.registrationType,
                    validUpto: doc.validUpto,
                    qualifications: doc.qualifications,
                    titlesStr: doc.titlesStr,
                    degreesStr: doc.degreesStr,
                    titles: doc.titles,
                    degrees: doc.degrees,
                    practiceStartingDate: doc.practiceStartingDate,
                    description: doc.description,
                    createdDate: doc.createdDate,
                    updatedDate: doc.updatedDate,
                    user: _user,
                    locations: doc.locations,
                  );
                  print(doctorObj);
                  await doctorService.updateDoctorProfile(doctorObj);
                  await emailService.userProfileUpdated(
                    profileProvider.user.email,
                    profileProvider.user.fullName,
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
        body: Consumer2<DoctorProvider, ProfileProvider>(
            builder: (context, doctorProvider, profileProvider, child) {
          Doctor doctor = doctorProvider.doctor;
          return Stack(
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
                                  imagePicker(doctor, profileProvider);
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
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        image: DecorationImage(
                                            image: profileProvider
                                                        .user.avatar ==
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
                              width: 20.0,
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
                                    fontSize: 17.0,
                                    fontFamily: "CenturyGothic",
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  doctor.registrationNo ?? "57418",
                                  style: TextStyle(
                                    color: _colors.grey,
                                    fontSize: 14.0,
                                    fontFamily: "CenturyGothic",
                                  ),
                                ),
                                SizedBox(
                                  height: 1.0,
                                ),
                                Text(
                                  profileProvider.user == null
                                      ? ""
                                      : profileProvider.user.phone ?? "",
                                  style: TextStyle(
                                    color: _colors.grey,
                                    fontSize: 14.0,
                                    fontFamily: "CenturyGothic",
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 6.0),
                            child: Text(
                              "Account",
                              style: TextStyle(
                                color: _colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                fontFamily: "CenturyGothic",
                              ),
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        EditCard(
                          text: profileProvider.user == null
                              ? ""
                              : profileProvider.user.email ?? "",
                          icon: Icons.email,
                          onPressed: () async {
                            bool isConnected = await CheckInternet()
                                .isInternetConnected(context);
                            if (isConnected == true) {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        CustomBottomSheetWithTextfieldAndSubmitbutton(
                                          inputFormatter: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[a-zA-Z0-9@.]+|\s')),
                                          ],
                                          title: "Update email account",
                                          hint: "Enter new gmail id",
                                          initialvalue: doctor.user.email,
                                          onChanged: (val) {
                                            setState(() {
                                              email = val;
                                            });
                                          },
                                          submitButtonName: "Update",
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            User _user = User(
                                              id: profileProvider.user.id,
                                              fullName:
                                                  profileProvider.user.fullName,
                                              email: email ??
                                                  profileProvider.user.email,
                                              type: profileProvider.user.type,
                                              landingUrl: profileProvider
                                                  .user.landingUrl,
                                              phone: profileProvider.user.phone,
                                              gender:
                                                  profileProvider.user.gender,
                                              username:
                                                  profileProvider.user.username,
                                              password:
                                                  profileProvider.user.password,
                                              avatar:
                                                  profileProvider.user.avatar,
                                              state: profileProvider.user.state,
                                              status:
                                                  profileProvider.user.status,
                                              createdDate: profileProvider
                                                  .user.createdDate,
                                              updatedDate: profileProvider
                                                  .user.updatedDate,
//                                                          role: profileProvider
//                                                              .user.role,
                                            );

                                            Doctor doctorObj = Doctor(
                                              id: doctor.id,
                                              registrationNo:
                                                  doctor.registrationNo,
                                              fatherName: doctor.fatherName,
                                              registrationDate:
                                                  doctor.registrationDate,
                                              registrationType:
                                                  doctor.registrationType,
                                              validUpto: doctor.validUpto,
                                              qualifications:
                                                  doctor.qualifications,
                                              titlesStr: doctor.titlesStr,
                                              degreesStr: doctor.degreesStr,
                                              titles: doctor.titles,
                                              degrees: doctor.degrees,
                                              practiceStartingDate:
                                                  doctor.practiceStartingDate,
                                              description: doctor.description,
                                              createdDate: doctor.createdDate,
                                              updatedDate: doctor.updatedDate,
                                              user: _user,
                                              locations: doctor.locations,
                                            );

                                            print(doctorObj);
                                            await doctorService
                                                .updateDoctorProfile(doctorObj);
                                            profileProvider.updateEmail(email);
                                            setState(() {
                                              isLoading = false;
                                            });

                                            await emailService
                                                .userProfileUpdated(
                                              email ??
                                                  profileProvider.user.email,
                                              profileProvider.user.fullName,
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),

                                        // For Loading
                                        isLoading
                                            ? Opacity(
                                                opacity: 0.7,
                                                child: Container(
                                                  height: 270.0,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
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
                                    );
                                  });
                            } else {
                              _toast.showDangerToast(
                                  "Please check your internet connection");
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 6.0),
                            child: Text(
                              "Degree",
                              style: TextStyle(
                                color: _colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                fontFamily: "CenturyGothic",
                              ),
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        EditCard(
                          text: doctorProvider.doctor == null
                              ? ""
                              : doctorProvider.doctor.degreesStr ?? "No degree",
                          icon: Icons.format_align_justify,
                          onPressed: () async {
                            bool isConnected = await CheckInternet()
                                .isInternetConnected(context);
                            if (isConnected == true) {
                              //
                              bool mbbsDegree = false;
                              bool fcpsDegree = false;
                              String degreeWithPipe = doctor.degreesStr;
                              if (degreeWithPipe == "" ||
                                  degreeWithPipe == "No degrees" ||
                                  degreeWithPipe == null) {
                                print("Noo value");
                              } else {
                                String degreeWithoutPipe =
                                    degreeWithPipe.replaceAll(" |", "");
                                List<String> degreeList =
                                    degreeWithoutPipe.split(new RegExp(r" "));
                                for (var i in degreeList) {
                                  if (i == "MBBS") {
                                    setState(() {
                                      mbbsDegree = true;
                                    });
                                  } else if (i == "FCPS") {
                                    setState(() {
                                      fcpsDegree = true;
                                    });
                                  }
                                }
                                print("MBBS = $mbbsDegree");
                                print("FCPS = $fcpsDegree");
                                print(degreeList);
                              }

                              //
                              setState(() {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Stack(
                                        children: [
                                          DegreeCheckBox(
                                            doctor: doctor,
                                            doctorProvider: doctorProvider,
                                            profileProvider: profileProvider,
                                            savedFcps: fcpsDegree,
                                            savedMbbs: mbbsDegree,
                                          )
                                        ],
                                      );
                                    });
                              });
                            } else {
                              _toast.showDangerToast(
                                  "Please check your internet connection");
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 6.0),
                            child: Text(
                              "Title",
                              style: TextStyle(
                                color: _colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                fontFamily: "CenturyGothic",
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        EditCard(
                          text: doctorProvider.doctor == null
                              ? ""
                              : doctorProvider.doctor.titlesStr ?? "No titles",
                          icon: Icons.backpack,
                          onPressed: () async {
                            bool isConnected = await CheckInternet()
                                .isInternetConnected(context);
                            if (isConnected == true) {
                              //
                              bool dentistTitle = false;
                              bool phyTitle = false;
                              String titleWithPipe = doctor.titlesStr;
                              if (titleWithPipe == "" ||
                                  titleWithPipe == "No titles" ||
                                  titleWithPipe == null) {
                                print("Noo value");
                              } else {
                                String titleWithoutPipe =
                                    titleWithPipe.replaceAll(" |", "");
                                List<String> titleList =
                                    titleWithoutPipe.split(new RegExp(r" "));
                                for (var i in titleList) {
                                  if (i == "Dentist") {
                                    setState(() {
                                      dentistTitle = true;
                                    });
                                  } else if (i == "Physician") {
                                    setState(() {
                                      phyTitle = true;
                                    });
                                  }
                                }
                                print("Dentist = $dentistTitle");
                                print("Physician = $phyTitle");
                                print(titleList);
                              }
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        TitleCheckBox(
                                          doctor: doctor,
                                          doctorProvider: doctorProvider,
                                          profileProvider: profileProvider,
                                          savedDentist: dentistTitle,
                                          savedPhy: phyTitle,
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              _toast.showDangerToast(
                                  "Please check your internet connection");
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
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

                                  locationsProvider.locations = null;
                                  schedulesProvider.finalSchedules = null;
                                  slotsProvider.slots = null;

                                  Navigator.pushReplacement(
                                      context, // ROUTING
                                      MaterialPageRoute(
                                          builder: (context) => MyApp()));
                                } else {
                                  _toast.showDangerToast(
                                      "Please check your internet connection");
                                }

                                // appointmentsProvider
                                //         .patientScheduleAppointments =
                                //     null;
                                //profileProvider.user = null;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
              // For Loading
              isLoading
                  ? Opacity(
                      opacity: 0.7,
                      child: Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: _colors.greyTheme,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            )),
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
          );
        }));
  }
}

class EditCard extends StatelessWidget {
  String text;
  Function onPressed;
  IconData icon;

  EditCard({this.text, this.onPressed, this.icon});

  CustomThemeColors _colors = CustomThemeColors();
  CustomToast _toast = CustomToast();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      bevel: 9,
      color: Color(0xFFECF0F3),
      curveType: CurveType.flat,
      decoration: NeumorphicDecoration(
          color: _colors.greyTheme, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.only(top: 11, left: 20, right: 20, bottom: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(
                      icon,
                      color: _colors.grey,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      text,
                      style: TextStyle(
                          color: _colors.grey,
                          fontSize: _sizes.smallTextSize,
                          fontWeight: FontWeight.w400,
                          fontFamily: "CenturyGothic"),
                    ),
                  ),
                  CustomButtonSmall(
                    color: _colors.green,
                    name: "Edit",
                    pressed: onPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DegreeCheckBox extends StatefulWidget {
  Doctor doctor;
  bool savedMbbs;
  bool savedFcps;
  DoctorProvider doctorProvider;
  ProfileProvider profileProvider;

  DegreeCheckBox(
      {this.doctor,
      this.doctorProvider,
      this.profileProvider,
      this.savedFcps,
      this.savedMbbs});

  @override
  _DegreeCheckBoxState createState() => _DegreeCheckBoxState();
}

class _DegreeCheckBoxState extends State<DegreeCheckBox> {
  CustomToast _toast = CustomToast();

  bool mbbs = false;
  bool fcps = false;
  bool isLoading = false;
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();
  DoctorService doctorService = DoctorService();
  EmailService emailService = EmailService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: _colors.greyTheme,
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              width: double.infinity,
              child: Column(
                children: [
                  CheckboxListTile(
                      checkColor: _colors.green,
                      activeColor: _colors.greyTheme,
                      title: Text(
                        "MBBS",
                        style: TextStyle(color: _colors.green),
                      ),
                      value: widget.savedMbbs,
                      onChanged: (bool val) {
                        setState(() {
                          widget.savedMbbs = val;
                        });
                      }),
                  CheckboxListTile(
                      checkColor: _colors.green,
                      activeColor: _colors.greyTheme,
                      title: Text(
                        "FCPS",
                        style: TextStyle(color: _colors.green),
                      ),
                      value: widget.savedFcps,
                      onChanged: (bool val) {
                        setState(() {
                          widget.savedFcps = val;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    name: "Update",
                    pressed: () async {
                      bool isConnected =
                          await CheckInternet().isInternetConnected(context);
                      if (isConnected == true) {
                        String generateDegreeWithPipe() {
                          if (widget.savedMbbs && widget.savedFcps) {
                            return "MBBS | FCPS";
                          } else if (widget.savedMbbs == false &&
                              widget.savedFcps == false) {
                            return "No degrees";
                          } else if (widget.savedMbbs == true &&
                              widget.savedFcps == false) {
                            return "MBBS";
                          } else {
                            return "FCPS";
                          }
                        }

                        setState(() {
                          isLoading = true;
                        });
                        Doctor doctorObj = Doctor(
                          id: widget.doctor.id,
                          registrationNo: widget.doctor.registrationNo,
                          fatherName: widget.doctor.fatherName,
                          registrationDate: widget.doctor.registrationDate,
                          registrationType: widget.doctor.registrationType,
                          validUpto: widget.doctor.validUpto,
                          qualifications: widget.doctor.qualifications,
                          titlesStr: widget.doctor.titlesStr,
                          degreesStr: generateDegreeWithPipe(),
                          titles: widget.doctor.titles,
                          degrees: widget.doctor.degrees,
                          practiceStartingDate:
                              widget.doctor.practiceStartingDate,
                          description: widget.doctor.description,
                          createdDate: widget.doctor.createdDate,
                          updatedDate: widget.doctor.updatedDate,
                          user: widget.profileProvider.user,
                          locations: widget.doctor.locations,
                        );

                        print(doctorObj);
                        await doctorService.updateDoctorProfile(doctorObj);
                        widget.doctorProvider
                            .updateDegreeStr(generateDegreeWithPipe());
                        setState(() {
                          isLoading = false;
                        });

                        await emailService.userProfileUpdated(
                          widget.profileProvider.user.email,
                          widget.profileProvider.user.fullName,
                        );
                        Navigator.pop(context);
                      } else {
                        _toast.showDangerToast(
                            "Please check your internet connection");
                      }
                    },
                    color: _colors.green,
                  ),
                  SizedBox(
                    height: 20,
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
                child: Container(
                  height: 200.0,
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
    );
  }
}

class TitleCheckBox extends StatefulWidget {
  Doctor doctor;
  DoctorProvider doctorProvider;
  ProfileProvider profileProvider;
  bool savedDentist;
  bool savedPhy;

  TitleCheckBox(
      {this.doctor,
      this.doctorProvider,
      this.profileProvider,
      this.savedDentist,
      this.savedPhy});

  @override
  _TitleCheckBoxState createState() => _TitleCheckBoxState();
}

class _TitleCheckBoxState extends State<TitleCheckBox> {
  CustomToast _toast = CustomToast();

  bool dentist = false;
  bool physician = false;
  bool isLoading = false;
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();
  DoctorService doctorService = DoctorService();
  EmailService emailService = EmailService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: _colors.greyTheme,
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              width: double.infinity,
              child: Column(
                children: [
                  CheckboxListTile(
                      checkColor: _colors.green,
                      activeColor: _colors.greyTheme,
                      title: Text(
                        "Dentist",
                        style: TextStyle(color: _colors.green),
                      ),
                      value: widget.savedDentist,
                      onChanged: (bool val) {
                        setState(() {
                          widget.savedDentist = val;
                        });
                      }),
                  CheckboxListTile(
                      checkColor: _colors.green,
                      activeColor: _colors.greyTheme,
                      title: Text(
                        "Physician",
                        style: TextStyle(color: _colors.green),
                      ),
                      value: widget.savedPhy,
                      onChanged: (bool val) {
                        setState(() {
                          widget.savedPhy = val;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    name: "Update",
                    pressed: () async {
                      bool isConnected =
                          await CheckInternet().isInternetConnected(context);
                      if (isConnected == true) {
                        String generateTitleWithPipe() {
                          if (widget.savedDentist && widget.savedPhy) {
                            return "Dentist | Physician";
                          } else if (widget.savedDentist == false &&
                              widget.savedPhy == false) {
                            return "No titles";
                          } else if (widget.savedDentist == true &&
                              widget.savedPhy == false) {
                            return "Dentist";
                          } else {
                            return "Physician";
                          }
                        }

                        setState(() {
                          isLoading = true;
                        });
                        Doctor doctorObj = Doctor(
                          id: widget.doctor.id,
                          registrationNo: widget.doctor.registrationNo,
                          fatherName: widget.doctor.fatherName,
                          registrationDate: widget.doctor.registrationDate,
                          registrationType: widget.doctor.registrationType,
                          validUpto: widget.doctor.validUpto,
                          qualifications: widget.doctor.qualifications,
                          titlesStr: generateTitleWithPipe(),
                          degreesStr: widget.doctor.degreesStr,
                          titles: widget.doctor.titles,
                          degrees: widget.doctor.degrees,
                          practiceStartingDate:
                              widget.doctor.practiceStartingDate,
                          description: widget.doctor.description,
                          createdDate: widget.doctor.createdDate,
                          updatedDate: widget.doctor.updatedDate,
                          user: widget.profileProvider.user,
                          locations: widget.doctor.locations,
                        );

                        print(doctorObj);
                        await doctorService.updateDoctorProfile(doctorObj);
                        widget.doctorProvider
                            .updateTitleStr(generateTitleWithPipe());
                        setState(() {
                          isLoading = false;
                        });

                        await emailService.userProfileUpdated(
                          widget.profileProvider.user.email,
                          widget.profileProvider.user.fullName,
                        );
                        Navigator.pop(context);
                      } else {
                        _toast.showDangerToast(
                            "Please check your internet connection");
                      }
                    },
                    color: _colors.green,
                  ),
                  SizedBox(
                    height: 20,
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
                child: Container(
                  height: 200.0,
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
    );
  }
}
