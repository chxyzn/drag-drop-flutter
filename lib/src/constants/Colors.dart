import 'package:flutter/material.dart';

class CustomColor {
  static const Color white = Colors.white;
  static const Color primaryColor = Color(0xff1C4C82);
  static const Color primary60Color = Color(0xff7794B4);
  static const Color textfieldBGColor = Color(0xffF2F7FC);
  static const Color imgBgColorGrey = Color(0xffD9D9D9);
  static const Color goldStarColor = Color(0xffF1C644);
  static const Color greenTextColor = Color(0xff007000);
  static const Color darkerDarkBlack = Color(0xff111111);
  static const Color dividerGrey = Color(0xffE6E6E6);
  static const Color tileBgBlue = Color(0xffF2F7FC);
  static const Color logOutDangerRed = Color(0xffED4337);
  static const Color backgrondBlue = Color(0xffF2F7FC);
  static const Color gridBorderColor = Color(0xffE2E2E2);

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
  final Color fungi = Color.fromARGB(255, 22, 231, 144);
  final Color purple = Color(0xff800080);
  final Color pink = Color(0xffFFC0CB);
  final Color brown = Color(0xffA52A2A);
  final Color cyan = Color(0xff00FFFF);
  final Color magenta = Color(0xffFF00FF);
  final Color gray = Color(0xff808080);

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
      case 5:
        return fungi;
      case 6:
        return purple;
      case 7:
        return pink;
      case 8:
        return brown;
      case 9:
        return cyan;
      case 10:
        return magenta;
      case 11:
        return gray;
      default:
        return green;
    }
  }
}
