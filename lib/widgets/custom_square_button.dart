import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:neumorphic/neumorphic.dart';

class CustomSquareButton extends StatelessWidget {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  //SIZES
  CustomSizes _sizes = CustomSizes();

  VoidCallback pressed;
  IconData icon;
  Color color;

  CustomSquareButton({this.pressed, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _sizes.squareButtonSize,
      height: _sizes.squareButtonSize,
      child: NeuButton(
        decoration: NeumorphicDecoration(
            color: _colors.greyTheme, borderRadius: BorderRadius.circular(20)),
        onPressed: pressed,
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
