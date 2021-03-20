import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:neumorphic/neumorphic.dart';

class CustomButtonSmall extends StatefulWidget {
  VoidCallback pressed;
  String name;
  Color color;

  CustomButtonSmall({this.pressed, this.name, this.color});

  @override
  _CustomButtonSmallState createState() => _CustomButtonSmallState();
}

class _CustomButtonSmallState extends State<CustomButtonSmall> {
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
    return Listener(
      onPointerDown: _incrementDown,
      onPointerUp: _incrementUp,
      child: Container(
        height: 30,
        width: 80.0,
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
                  fontSize: 9.0,
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
