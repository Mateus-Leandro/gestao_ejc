import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_add_button.dart';
import 'package:gestao_ejc/components/custom_text_field.dart';

class CustomRowAddAndSearch extends StatelessWidget {
  final String messageButton;
  final Function functionButton;
  final bool showAddButton;

  final TextInputType inputType;
  final TextEditingController controller;
  final String messageTextField;
  final Function functionTextField;

  const CustomRowAddAndSearch({
    super.key,
    required this.messageButton,
    required this.functionButton,
    required this.showAddButton,
    required this.inputType,
    required this.controller,
    required this.messageTextField,
    required this.functionTextField,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showAddButton) ...[
          CustomAddButton(
            message: messageButton,
            function: functionButton,
            icon: const Icon(Icons.add),
          ),
        ],
        CustomTextField(
          inputType: TextInputType.text,
          controller: controller,
          text: messageTextField,
          funtion: functionTextField,
        ),
      ],
    );
  }
}
