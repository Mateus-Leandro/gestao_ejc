import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/controllers/auth_controller.dart';
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

  void callLogOut({required BuildContext context}) {
    final authController = getIt<AuthController>();
    try {
      authController.logOut();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } catch (e) {
      CustomSnackBar.show(
          context: context, message: e.toString(), colorBar: Colors.red);
    }
  }
}
