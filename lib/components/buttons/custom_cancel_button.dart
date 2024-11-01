import 'package:flutter/material.dart';

class CustomCancelButton extends ElevatedButton {
  CustomCancelButton({
    super.key,
    required super.onPressed,
  }) : super(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 24.0,
            ),
            textStyle: const TextStyle(
              fontSize: 14,
            ),
          ),
          child: const Text('Cancelar', style: TextStyle(
            color: Colors.white
          ),),
        );
}
