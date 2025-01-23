import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    required Color colorBar,
  }) : super(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: colorBar,
        );

  static void show({
    required BuildContext context,
    required String message,
    required Color colorBar,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(message: message, colorBar: colorBar),
    );
  }
}
