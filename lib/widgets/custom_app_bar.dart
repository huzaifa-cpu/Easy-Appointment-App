import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/profile_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/main.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/firebase_services/firebase_auth_service.dart';
import 'package:flutter_ea_mobile_app/services/session_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_colors.dart';
import 'custom_sizes.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  bool notificationButton;
  bool logoutButton;
  VoidCallback backButtonPressed;
  VoidCallback notificationButtonPressed;
  String title;

  CustomAppBar(
      {this.title,
      this.backButtonPressed,
      this.notificationButton,
      this.logoutButton,
      this.notificationButtonPressed});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  SessionService sessionService = SessionService();
  CustomToast _toast = CustomToast();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _colors.greyTheme,
      elevation: 0.0,
      iconTheme: IconThemeData(color: _colors.grey),
      bottomOpacity: 0.0,
      actions: [
        notificationButton
            ? IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: _colors.grey,
                ),
                onPressed: notificationButtonPressed,
              )
            : logoutButton
                ? Consumer5<ProfileProvider, LocationsProvider,
                    SchedulesProvider, SlotsProvider, AppointmentsProvider>(
                    builder: (context,
                            profileProvider,
                            locationsProvider,
                            schedulesProvider,
                            slotsProvider,
                            appointmentsProvider,
                            child) =>
                        IconButton(
                            icon: Icon(Icons.logout),
                            onPressed: () async {
                              bool isConnected = await CheckInternet()
                                  .isInternetConnected(context);
                              if (isConnected == true) {
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
                                // appointmentsProvider.patientScheduleAppointments =
                                //     null;
                                appointmentsProvider
                                    .doctorAppointmentBySlotDate = null;

                                Navigator.pushReplacement(
                                    context, // ROUTING
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()));
                              } else {
                                _toast.showDangerToast(
                                    "Please check your internet connection");
                              }
                            }),
                  )
                : SizedBox(
                    height: 0.0,
                  ),
      ],
      title: Text(
        "$title",
        style: TextStyle(
          color: _colors.grey,
          fontSize: _sizes.titleTextSize,
          fontWeight: FontWeight.w900,
          fontFamily: "CenturyGothic",
        ),
      ),
      centerTitle: true,
    );
  }
}
