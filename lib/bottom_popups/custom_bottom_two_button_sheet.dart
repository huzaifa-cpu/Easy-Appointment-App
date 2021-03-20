import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:neumorphic/neumorphic.dart';

class CustomBottomTwoButtonSheet extends StatefulWidget {
  String title1;
  String title2;
  Color titleColor1;
  Color titleColor2;
  Function onPressed1;
  Function onPressed2;
  Function onPressed3;

  CustomBottomTwoButtonSheet(
      {this.title1,
      this.title2,
      this.titleColor1,
      this.titleColor2,
      this.onPressed1,
      this.onPressed3,
      this.onPressed2});
  @override
  _CustomBottomTwoButtonSheetState createState() =>
      _CustomBottomTwoButtonSheetState();
}

class _CustomBottomTwoButtonSheetState
    extends State<CustomBottomTwoButtonSheet> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
          color: _colors.greyTheme,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          )),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: widget.onPressed3,
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 50,
              color: _colors.grey,
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 45.0,
                  width: 150.0,
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  child: NeuButton(
                    decoration: NeumorphicDecoration(
                        color: _colors.greyTheme,
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: widget.onPressed1,
                    child: Text(
                      widget.title1,
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.titleColor1,
                        fontFamily: "CenturyGothic",
                        fontSize: 8.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 45.0,
                  width: 150.0,
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  child: NeuButton(
                    decoration: NeumorphicDecoration(
                        color: _colors.greyTheme,
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: widget.onPressed2,
                    child: Text(
                      widget.title2,
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.titleColor2,
                        fontFamily: "CenturyGothic",
                        fontSize: 8.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
