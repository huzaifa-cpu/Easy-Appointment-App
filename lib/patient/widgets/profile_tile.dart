import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';

class ProfileTile extends StatelessWidget {
  String text;
  IconData icon;

  ProfileTile(this.text, this.icon);

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: _colors.grey,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text(
          text,
          style: TextStyle(
              color: _colors.grey,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              fontFamily: "CenturyGothic"),
        ),
      ],
    );
  }
}
