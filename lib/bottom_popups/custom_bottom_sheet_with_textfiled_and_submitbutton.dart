import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_textfield.dart';

class CustomBottomSheetWithTextfieldAndSubmitbutton extends StatefulWidget {
  String title;
  String hint;
  String submitButtonName;
  VoidCallback onPressed;
  Function onChanged;
  String initialvalue;
  List<TextInputFormatter> inputFormatter;

  CustomBottomSheetWithTextfieldAndSubmitbutton(
      {this.title,
      this.hint,
      this.submitButtonName,
      this.inputFormatter,
      this.initialvalue,
      this.onPressed,
      this.onChanged});

  @override
  _CustomBottomSheetWithTextfieldAndSubmitbuttonState createState() =>
      _CustomBottomSheetWithTextfieldAndSubmitbuttonState();
}

class _CustomBottomSheetWithTextfieldAndSubmitbuttonState
    extends State<CustomBottomSheetWithTextfieldAndSubmitbutton> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: _colors.greyTheme,
              borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
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
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: _sizes.largeTextSize,
                    fontWeight: FontWeight.bold,
                    color: _colors.grey,
                    fontFamily: "CenturyGothic",
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                CustomTextField(
                  initialValue: widget.initialvalue,
                  hint: widget.hint,
                  type: TextInputType.text,
                  onChanged: widget.onChanged,
                  inputFormatter: widget.inputFormatter,
                ),
                SizedBox(
                  height: 20.0,
                ),
                CustomButton(
                  name: widget.submitButtonName,
                  pressed: widget.onPressed,
                  color: _colors.green,
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
