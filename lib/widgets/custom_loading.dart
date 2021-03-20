import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';

class CustomLoading extends StatelessWidget {
  final CustomThemeColors _colors = CustomThemeColors();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        // backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(_colors.green),
      ),
    );
  }
}
