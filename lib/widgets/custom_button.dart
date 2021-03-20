import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:neumorphic/neumorphic.dart';

class CustomButton extends StatefulWidget {
  CustomButton({this.pressed, this.name, this.color});

  VoidCallback pressed;
  String name;
  Color color;
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  //SIZES
  CustomSizes _sizes = CustomSizes();

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  bool upward = true;

  void _incrementDown(PointerEvent details) {
    setState(() {
      upward = false;
    });
  }

  void _incrementUp(PointerEvent details) {
    setState(() {
      upward = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Listener(
      onPointerDown: _incrementDown,
      onPointerUp: _incrementUp,
      child: Container(
        height: _sizes.buttonHeight,
        width: width * 0.8,
        child: GestureDetector(
          onTap: widget.pressed,
          child: NeuCard(
            bevel: 9,
            curveType: upward ? CurveType.flat : CurveType.emboss,
            decoration: NeumorphicDecoration(
                color: _colors.greyTheme,
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: widget.color,
                  fontFamily: "CenturyGothic",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
