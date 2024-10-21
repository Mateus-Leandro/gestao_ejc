import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.decoration,
    required this.validator,
    required this.obscure,
    this.functionSubimitted,
    this.focusNode,
    this.maxLength,
    this.capitalizeFirstLetter = false,
  });

  final TextEditingController controller;
  final InputDecoration decoration;
  final FormFieldValidator<String> validator;
  final bool obscure;
  final void Function(String)? functionSubimitted;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool capitalizeFirstLetter;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: widget.decoration,
      controller: widget.controller,
      validator: widget.validator,
      onFieldSubmitted: widget.functionSubimitted,
      obscureText: widget.obscure,
      focusNode: widget.focusNode,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      onChanged: (value) {
        if (value.isNotEmpty && widget.capitalizeFirstLetter) {
          final capitalized =
              value[0].toUpperCase() + value.substring(1);

          if (capitalized != value) {
            widget.controller.value = widget.controller.value.copyWith(
              text: capitalized,
              selection: TextSelection.collapsed(offset: capitalized.length),
            );
          }
        }
      },
    );
  }
}
