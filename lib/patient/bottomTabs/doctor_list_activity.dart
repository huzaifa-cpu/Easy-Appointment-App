import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/notifications_screen.dart';
import 'package:flutter_ea_mobile_app/patient/widgets/doc_card.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/doctor_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';

class Doctor extends StatefulWidget {
  @override
  _DoctorState createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  final DoctorService doctorService = DoctorService();
  bool isLoading = false;
  CustomToast _toast = CustomToast();

  enableLoading() {
    setState(() {
      isLoading = true;
    });
  }

  disableLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Scaffold(
            backgroundColor: _colors.greyTheme,
            appBar: CustomAppBar(
              title: "Doctors",
              notificationButton: true,
              notificationButtonPressed: () async {
                bool isConnected =
                    await CheckInternet().isInternetConnected(context);
                if (isConnected == true) {
                  Navigator.push(
                      context, // ROUTING
                      MaterialPageRoute(
                          builder: (context) => NotificationsScreen()));
                } else {
                  _toast
                      .showDangerToast("Please check your internet connection");
                }
              },
              backButtonPressed: () {},
              logoutButton: false,
            ),
            body: FutureBuilder(
                future: doctorService.getDoctorList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> doctors = snapshot.data;
                    if (doctors.length != 0) {
                      return ListView.builder(
                          itemCount: doctors.length,
                          itemBuilder: (BuildContext context, int i) {
                            return DoctorCard(
                              doctor: doctors[i],
                              enableLoading: enableLoading,
                              disableLoading: disableLoading,
                            );
                          });
                    } else {
                      return Center(
                          child: Text(
                        "No Doctors yet",
                        style: TextStyle(
                            color: _colors.grey, fontFamily: "CenturyGothic"),
                      ));
                    }
                  }
                  return CustomLoading();
                })),
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
