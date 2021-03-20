import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

import 'custom_colors.dart';
import 'custom_sizes.dart';

class CustomLocationDropDown extends StatelessWidget {
  String locationName;
  VoidCallback pressed;

  CustomLocationDropDown({this.locationName, this.pressed});

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: NeuCard(
        height: _sizes.dropDownHeight,
        curveType: CurveType.emboss,
        bevel: 12,
        decoration: NeumorphicDecoration(
            color: _colors.greyTheme, borderRadius: BorderRadius.circular(30)),
        child: NeuButton(
          decoration: NeumorphicDecoration(
              color: _colors.greyTheme,
              borderRadius: BorderRadius.circular(20)),
          onPressed: pressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.location_on,
                    size: 15.0,
                    color: _colors.green,
                  )),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                flex: 10,
                child: Text(
                  locationName,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: _colors.green,
                    fontFamily: "CenturyGothic",
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: _colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
