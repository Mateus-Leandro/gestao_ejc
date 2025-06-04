import 'package:flutter/material.dart';

class Utils {
  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static double screenWidthSize(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width;

  static double screenHeightSize(BuildContext ctx) =>
      MediaQuery.of(ctx).size.height;
}
