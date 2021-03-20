import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:neumorphic/neumorphic.dart';

class CustomTextField extends StatelessWidget {
  String hint;
  String initialValue;
  TextInputType type;
  TextEditingController textEditingController;
  List<TextInputFormatter> inputFormatter;
  bool readOnly;
  Function validator;

  CustomTextField(
      {this.hint,
      this.type,
      this.textEditingController,
      this.inputFormatter,
      this.onChanged,
      this.validator,
      this.readOnly,
      this.initialValue});

  ValueChanged onChanged;

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();
  bool readOnlyDefault = false;

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      height: _sizes.buttonHeight,
      width: _sizes.buttonWidth,
      curveType: CurveType.emboss,
      bevel: 12,
      decoration: NeumorphicDecoration(
          color: _colors.greyTheme, borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        validator: validator,
        readOnly: readOnly == null
            ? readOnlyDefault
            : readOnly
                ? readOnly
                : readOnlyDefault,
        initialValue: initialValue,
        inputFormatters: inputFormatter,
        onChanged: onChanged,
        controller: textEditingController,
        style: TextStyle(fontFamily: "CenturyGothic", fontSize: 12.0),
        keyboardType: type,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: 12.0,
          ),
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
