import 'package:flutter/material.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FunctionScreen {
  String? call({
    required BuildContext context,
    required int? indexMenuSelected,
    required String route,
    required bool popActualScreen,
    int? indexMenu,
  }) {
    if (indexMenuSelected != indexMenu) {
      try {
        if (popActualScreen) {
          Navigator.of(context).pop();
        }
        Navigator.pushNamed(context, route);
      } catch (e) {
        return "Erro ao acessar tela: ${e}";
      }
    }
    return null;
  }

  String? callLogOut({required BuildContext context}) {
    final authService = getIt<AuthService>();
    try {
      authService.logOut();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      return null;
    } catch (e) {
      return "Erro ao realizar logout: ${e}";
    }
  }
}
