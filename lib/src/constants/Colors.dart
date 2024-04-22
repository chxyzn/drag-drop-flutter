import 'package:flutter/material.dart';

class CustomColor {
  static const Color white = Colors.white;
  static const Color primaryColor = Color(0xff1C4C82);
  static const Color primary60Color = Color(0xff7794B4);
  static const Color textfieldBGColor = Color(0xffF2F7FC);
  static const Color goldStarColor = Color(0xffF1C644);
  static const Color greenTextColor = Color(0xff007000);
  static const Color backgrondBlue = Color(0xffF2F7FC);

  static const List<Color> gradientColor = [
    Colors.white,
    //Color(0xff7bc6d9),
    Color(0xff0298bf),
  ];
}

class GraphColors {
  final Color green = Color(0xff008000);
  final Color red = Color(0xffff0000);
  final Color orange = Color(0xffFF7F50);
  final Color black = Color(0xff000000);
  final Color blue = Color(0xff1C4C82);

  Color getColorFromId(int id) {
    switch (id) {
      case 0:
        return green;
      case 1:
        return red;
      case 2:
        return orange;
      case 3:
        return black;
      case 4:
        return blue;
      default:
        return green;
    }
  }
}
