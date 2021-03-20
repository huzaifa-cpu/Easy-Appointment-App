import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/location_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button_small.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';

class DeleteClinicConfirmation extends StatefulWidget {
  String status;
  VoidCallback pressedNo;
  Location location;
  LocationsProvider locationsProvider;

  DeleteClinicConfirmation(
      {this.status, this.pressedNo, this.location, this.locationsProvider});

  @override
  _DeleteClinicConfirmationState createState() =>
      _DeleteClinicConfirmationState();
}

class _DeleteClinicConfirmationState extends State<DeleteClinicConfirmation> {
  CustomThemeColors _colors = CustomThemeColors();
  CustomStrings utils = CustomStrings();
  LocationService locationService = LocationService();
  bool isLoading = false;
  CustomSizes _sizes = CustomSizes();
  CustomToast _toast = CustomToast();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          height: 150,
          color: _colors.greyTheme,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Expanded(
                child: Text(
                  "Sure you want to ${widget.status == utils.active ? utils.inactive : utils.active} this location ?",
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _colors.grey,
                    fontFamily: "CenturyGothic",
                    fontSize: _sizes.xsTextSize,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CustomButtonSmall(
                        name: "Yes",
                        pressed: () async {
                          bool isConnected = await CheckInternet()
                              .isInternetConnected(context);
                          if (isConnected == true) {
                            setState(() {
                              isLoading = true;
                            });
                            int locationId = widget.location.id;
                            print("locationId: $locationId");
                            //BODY
                            Location location = Location(
                              id: locationId,
                              address: widget.location.address,
                              name: widget.location.name,
                              fee: widget.location.fee,
                              clinicType: widget.location.clinicType,
                              state: widget.location.state,
                              status: widget.status == utils.active
                                  ? utils.inactive
                                  : utils.active,
                              createdDate: widget.location.createdDate,
                              updatedDate: widget.location.updatedDate,
                              doctor: widget.location.doctor,
                              schedules: widget.location.schedules,
                            );
                            widget.locationsProvider.updateLocation(location);
                            setState(() {
                              isLoading = false;
                            });
                            var jsonBody = jsonEncode(location);
                            //REQUEST
                            await locationService.updateLocation(
                                jsonBody, locationId);

                            Navigator.pop(context);
                          } else {
                            _toast.showDangerToast(
                                "Please check your internet connection");
                          }
                        },
                        color: _colors.red,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtonSmall(
                        name: "No",
                        pressed: widget.pressedNo,
                        color: _colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // For Loading
        isLoading
            ? Opacity(
                opacity: 0.7,
                child: Container(
                  height: 100,
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
