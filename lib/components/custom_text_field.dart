import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType inputType;
  final TextEditingController controller;
  final String text;
  final Function funtion;

  const CustomTextField(
      {super.key,
      required this.inputType,
      required this.controller,
      required this.text,
      required this.funtion});

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = getIt<AppTheme>();
    Timer? debounce;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: TextField(
          keyboardType: inputType,
          style: TextStyle(color: appTheme.colorBackgroundButton),
          controller: controller,
          decoration: InputDecoration(
            hintText: text,
            icon: Icon(Icons.search_outlined, color: appTheme.primaryColor),
            border: InputBorder.none,
          ),
          onChanged: (text) {
            if (debounce?.isActive ?? false) {
              debounce!.cancel();
            }
            debounce = Timer(const Duration(milliseconds: 500), () {
              funtion();
            });
          },
        ),
      ),
    );
  }
}
