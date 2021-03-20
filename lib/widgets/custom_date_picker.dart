import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

import 'custom_colors.dart';

class CustomDatePicker extends StatefulWidget {
  final DatePickerController datePickerController;
  Function onDateChanged;

  CustomDatePicker({this.datePickerController, this.onDateChanged});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  CustomThemeColors _colors = CustomThemeColors();

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      bevel: 9,
      color: _colors.greyTheme,
      curveType: CurveType.flat,
      decoration: NeumorphicDecoration(
          color: _colors.greyTheme, borderRadius: BorderRadius.circular(30)),
      child: DatePicker(
        DateTime.now(),
        height: 65,
        daysCount: 7,
        controller: widget.datePickerController,
        dayTextStyle: TextStyle(
          fontSize: 8.0,
          fontWeight: FontWeight.bold,
          color: _colors.green,
          fontFamily: "CenturyGothic",
        ),
        monthTextStyle: TextStyle(
          fontSize: 8.0,
          fontWeight: FontWeight.bold,
          color: _colors.green,
          fontFamily: "CenturyGothic",
        ),
        dateTextStyle: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: _colors.green,
          fontFamily: "CenturyGothic",
        ),
        selectionColor: _colors.green,
        selectedTextColor: Colors.white,
        initialSelectedDate: DateTime.now(),
        onDateChange: widget.onDateChanged,
      ),
    );
  }
}
