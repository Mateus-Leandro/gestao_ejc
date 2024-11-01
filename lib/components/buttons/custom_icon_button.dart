import 'package:flutter/material.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class CustomIconButton extends StatelessWidget {
  final String message;
  final Function function;
  final Icon icon;
  final Color? colorButton;

  const CustomIconButton(
      {super.key,
      required this.message,
      required this.function,
      required this.icon,
      this.colorButton});

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = getIt<AppTheme>();
    return Tooltip(
      message: message,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: IconButton(
          onPressed: () {
            function();
          },
          icon: icon,
          style: IconButton.styleFrom(
            backgroundColor: colorButton ?? appTheme.colorBackgroundButton,
            foregroundColor: appTheme.colorForegroundButton,
          ),
        ),
      ),
    );
  }
}
