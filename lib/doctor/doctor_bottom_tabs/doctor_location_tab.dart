import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/create_location_activity.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/create_location_and_schedule_activity.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/notifications_screen.dart';
import 'package:flutter_ea_mobile_app/doctor/widgets/location_card.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/location_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class LocationsTab extends StatefulWidget {
  //COLORS
  @override
  _LocationsTabState createState() => _LocationsTabState();
}

class _LocationsTabState extends State<LocationsTab> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  LocationService locationService = LocationService();
  CustomToast _toast = CustomToast();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _colors.greyTheme,
        appBar: AppBar(
          bottomOpacity: 0.0,
          centerTitle: true,
          backgroundColor: _colors.greyTheme,
          elevation: 0.0,
          title: Text(
            "Clinics",
            style: TextStyle(
              color: _colors.grey,
              fontSize: _sizes.titleTextSize,
              fontWeight: FontWeight.w900,
              fontFamily: "CenturyGothic",
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: _colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                    context, // ROUTING
                    MaterialPageRoute(
                        builder: (context) => CreateLocationAndScheduleScreen(
                              appBarTitle: "Create Clinic",
                              submitButtonName: "Create",
                              isClinicTab: true,
                              backButton: true,
                              backButtonPressed: () {
                                Navigator.pop(context);
                              },
                            )));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: _colors.grey,
              ),
              onPressed: () async {
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
            ),
          ],
        ),
        body: Consumer<LocationsProvider>(
            builder: (context, locationsProvider, child) => Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            itemCount: locationsProvider.locations.length,
                            itemBuilder: (context, index) {
                              return LocationCard(
                                  location: locationsProvider.locations[index],
                                  index: index);
                            }),
                      )
                    ],
                  ),
                )));
  }
}
