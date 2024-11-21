import 'package:flutter/material.dart';

class FunctionColor {
  String convertToHexadecimal(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  Color getFromHexadecimal(String colorHex) {
    return Color(int.parse(colorHex.replaceFirst('#', '0xff')));
  }
}
