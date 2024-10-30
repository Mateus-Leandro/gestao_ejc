import 'package:flutter/material.dart';

class CustomConfirmationButton extends ElevatedButton {
  CustomConfirmationButton({
    super.key,
    required super.onPressed,
  }) : super(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 24.0,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
      ),
    ),
    child: const Text('Confirmar', style: TextStyle(
        color: Colors.white
    ),),
  );
}
