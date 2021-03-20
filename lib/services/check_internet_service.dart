import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button_small.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:flutter/material.dart';

class CheckInternet {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  CustomSizes _sizes = CustomSizes();
  CustomToast _toast = CustomToast();

  StreamSubscription<DataConnectionStatus> listener;
  var internetStatus = "Unknown";
  var contentmessage = "Unknown";

  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          internetStatus = "Connected to the Internet";
          contentmessage = "Connected to the Internet";
          _showDialog(internetStatus, contentmessage, context);
          break;
        case DataConnectionStatus.disconnected:
          internetStatus = "You are disconnected to the Internet. ";
          contentmessage = "Please check your internet connection";
          _showDialog(internetStatus, contentmessage, context);
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  void _showDialog(String title, String content, BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.only(top: 20, left: 15),
              actionsPadding: EdgeInsets.all(10),
              titlePadding: EdgeInsets.only(top: 20, left: 15),
              backgroundColor: _colors.greyTheme,
              title: Text(
                "Not Connected",
                textScaleFactor: 0.9,
                style: TextStyle(color: _colors.green),
              ),
              content: Text(
                content,
                style: TextStyle(color: _colors.grey),
              ),
              actions: <Widget>[
                CustomButtonSmall(
                    pressed: () {
                      Navigator.of(context).pop();
                    },
                    color: _colors.red,
                    name: "Close")
              ]);
        });
  }

  Future<bool> isInternetConnected(BuildContext context) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      return true;
    }
    return false;
  }
}
