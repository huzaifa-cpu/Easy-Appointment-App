import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';

class Loaders extends StatefulWidget {
  @override
  _LoadersState createState() => _LoadersState();
}

class _LoadersState extends State<Loaders> {
  CustomThemeColors _colors = CustomThemeColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Scaffold(backgroundColor: _colors.greyTheme),
          CustomLoading()
        ],
      ),
    );
  }
}
