import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/buttons/custom_add_button.dart';
import 'package:gestao_ejc/components/text_fields/custom_text_field.dart';

class CustomSearchRow extends StatelessWidget {
  final String messageButton;
  final Function functionButton;
  final bool showButton;
  final Icon iconButton;
  final Color? buttonColor;

  final TextInputType inputType;
  final TextEditingController controller;
  final String messageTextField;
  final Function functionTextField;

  const CustomSearchRow({
    super.key,
    required this.messageButton,
    required this.functionButton,
    required this.showButton,
    this.buttonColor,
    required this.inputType,
    required this.controller,
    required this.messageTextField,
    required this.functionTextField,
    required this.iconButton,

  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showButton) ...[
          CustomAddButton(
            message: messageButton,
            function: functionButton,
            icon: iconButton,
            colorButton: buttonColor,
          ),
        ],
        CustomTextField(
          inputType: TextInputType.text,
          controller: controller,
          text: messageTextField,
          funtion: functionTextField,
        ),
        const SizedBox(height: 70)
      ],
    );
  }
}
