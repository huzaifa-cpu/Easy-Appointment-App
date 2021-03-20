import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom_colors.dart';
import 'custom_sizes.dart';

class CustomToast {
  CustomThemeColors _colors = CustomThemeColors();

  CustomSizes _sizes = CustomSizes();

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: _colors.green,
        textColor: Colors.white,
        fontSize: _sizes.smallTextSize);
  }

  showDangerToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: _colors.red,
        textColor: Colors.white,
        fontSize: _sizes.smallTextSize);
  }
}
