import 'package:flutter/material.dart';

class FunctionInputText {
  void capitalizeFirstLetter(
      {required String value, required TextEditingController controller}) {
    if (value.isNotEmpty) {
      final capitalized = value[0].toUpperCase() + value.substring(1);
      if (capitalized != value) {
        controller.value = controller.value.copyWith(
          text: capitalized,
          selection: TextSelection.collapsed(offset: capitalized.length),
        );
      }
    }
  }
}
