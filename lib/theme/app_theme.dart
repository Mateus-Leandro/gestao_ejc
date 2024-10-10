import 'package:flutter/material.dart';

class AppTheme{
  final Color primaryColor = const Color(0xFF001F3F);
  final Color secundaryColor = Colors.white;

  Color get colorBackGroundDrawer => primaryColor;
  Color get colorBackgroundTabBar => primaryColor;
  Color get colorBackgroundButton => primaryColor;
  Color get colorDarkInputText => primaryColor;
  Color get colorOuterFrame => primaryColor;
  Color get colorDarkText => primaryColor;
  Color get colorTopBar => primaryColor;
  Color get colorTile => primaryColor;

  Color get colorForegroundButton => secundaryColor;
  Color get colorLightInputText => secundaryColor;
  Color get colorLightButton => secundaryColor;
  Color get colorTextTopBar => secundaryColor;
  Color get colorInnerFrame => secundaryColor;
  Color get colorLightText => secundaryColor;

  final Color colorFocusTile = Colors.blue;
  final Color colorInativeUser = Colors.red;
  final Color colorAdminUser = Colors.blue;
  final Color colorSnackBarErro = Colors.red;
  final Color colorSnackBarSucess = Colors.green;
  final Color colorDivider = Colors.blue;
}