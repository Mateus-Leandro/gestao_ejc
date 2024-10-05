import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.decoration,
    required this.validator,
    required this.obscure,
    this.functionSubimitted,
    this.focusNode,
  });

  final TextEditingController controller;
  final InputDecoration decoration;
  final FormFieldValidator validator;
  final bool obscure;
  final Null Function(dynamic value)? functionSubimitted;
  final FocusNode? focusNode;

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
    );
  }
}
