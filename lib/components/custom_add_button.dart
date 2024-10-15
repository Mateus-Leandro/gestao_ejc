import 'package:flutter/material.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class CustomAddButton extends StatelessWidget {
  final String message;
  final Function function;
  final Icon icon;

  const CustomAddButton(
      {super.key,
      required this.message,
      required this.function,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = getIt<AppTheme>();
    return Tooltip(
      message: message,
      child: IconButton(
        onPressed: () {
          function();
        },
        icon: const Icon(Icons.add),
        style: IconButton.styleFrom(
          backgroundColor: appTheme.colorBackgroundButton,
          foregroundColor: appTheme.colorForegroundButton,
        ),
      ),
    );
  }
}
