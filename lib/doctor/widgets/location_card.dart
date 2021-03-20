import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/bottom_popups/delete_clinic_confirmation.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/create_location_activity.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/services/location_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button_small.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

class LocationCard extends StatefulWidget {
  Location location;
  int index;

  LocationCard({this.location, this.index});

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  CustomThemeColors _colors = CustomThemeColors();
  CustomStrings utils = CustomStrings();
  LocationService locationService = LocationService();
  bool isLoading = false;

  CustomSizes _sizes = CustomSizes();

  void isClinicInactive(String status) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LocationsProvider>(
            builder: (context, locationsProvider, child) =>
                DeleteClinicConfirmation(
              status: status,
              location: widget.location,
              locationsProvider: locationsProvider,
              pressedNo: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
      child: NeuCard(
        bevel: 9,
        color: _colors.greyTheme,
        curveType: CurveType.flat,
        decoration: NeumorphicDecoration(
            color: _colors.greyTheme, borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.location.name,
                      style: TextStyle(
                          fontSize: _sizes.smallTextSize,
                          color: _colors.grey,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.location.address,
                      style: TextStyle(
                          fontSize: 10.0,
                          color: _colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${utils.pakistaniCurrency}. ${widget.location.fee}",
                      style: TextStyle(
                          fontSize: 10.0,
                          color: _colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Expanded(
                flex: 2,
                child: CustomButtonSmall(
                  name: "Edit",
                  pressed: () {
                    Navigator.push(
                        context, // ROUTING
                        MaterialPageRoute(
                            builder: (context) => CreateLocationScreen(
                                  appBarTitle: "Update Clinic",
                                  index: widget.index,
                                  submitButtonName: "Update",
                                  backButton: true,
                                  location: widget.location,
                                  isEdit: true,
                                  isClinicTab: false,
                                  isSchedule: false,
                                  backButtonPressed: () {
                                    Navigator.pop(context);
                                  },
                                )));
                  },
                  color: _colors.green,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
//              Expanded(
//                flex: 3,
//                child: CustomButtonSmall(
//                  name: widget.location.status == utils.active
//                      ? utils.inactive
//                      : utils.active,
//                  pressed: () {
//                    isClinicInactive(widget.location.status);
//                  },
//                  color: widget.location.status == utils.active
//                      ? _colors.red
//                      : _colors.green,
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
