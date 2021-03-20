import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/doctor/doctor_bottom_tabs/doctor_bottom_navigation_bar.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/schedule_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

class DoctorScheduleLocationSelector extends StatefulWidget {
  @override
  _DoctorScheduleLocationSelectorState createState() =>
      _DoctorScheduleLocationSelectorState();
}

class _DoctorScheduleLocationSelectorState
    extends State<DoctorScheduleLocationSelector> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  CustomToast _toast = CustomToast();

  ScheduleService scheduleService = ScheduleService();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationsProvider>(
      builder: (context, locationsProvider, child) => Container(
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
            color: _colors.greyTheme,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            )),
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 50,
                  color: _colors.grey,
                ),
              ),
              Text(
                "Available locations",
                style: TextStyle(
                    fontSize: 17,
                    color: _colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Select a location for appointment",
                style: TextStyle(
                    fontSize: 14,
                    color: _colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: locationsProvider.locations.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: () async {
                          bool isConnected = await CheckInternet()
                              .isInternetConnected(context);
                          if (isConnected == true) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context, // ROUTING
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DoctorBottomNavigationBar(
                                          location: locationsProvider
                                              .locations[index],
                                          clinics: false,
                                          appoints: false,
                                          profiles: false,
                                          schedule: true,
                                        )));
                          } else {
                            _toast.showDangerToast(
                                "Please check your internet connection");
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            NeuCard(
                              width: 400,
                              color: _colors.greyTheme,
                              bevel: 9,
                              decoration: NeumorphicDecoration(
                                  color: _colors.greyTheme,
                                  borderRadius: BorderRadius.circular(30)),
                              curveType: CurveType.flat,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 15, bottom: 12, left: 15, right: 17),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: _colors.green,
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          locationsProvider
                                              .locations[index].name,
                                          style: TextStyle(
                                              fontSize: _sizes.smallTextSize,
                                              color: _colors.grey,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          locationsProvider
                                              .locations[index].address,
                                          style: TextStyle(
                                              fontSize: _sizes.smallTextSize,
                                              color: _colors.grey,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          locationsProvider.locations[index].fee
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: _sizes.smallTextSize,
                                              color: _colors.grey,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 21,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
