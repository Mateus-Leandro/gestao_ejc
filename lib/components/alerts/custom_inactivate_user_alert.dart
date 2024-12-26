import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CustomInactivateUserAlert extends StatelessWidget {
  const CustomInactivateUserAlert({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final UserController _userController = getIt<UserController>();
    final String action = user.active ? 'Inativar' : 'Ativar';

    return IconButton(
      onPressed: () {
        QuickAlert.show(
          context: context,
          type: action == 'Inativar'
              ? QuickAlertType.error
              : QuickAlertType.confirm,
          title: 'Deseja ${action} usuário?',
          animType: QuickAlertAnimType.slideInLeft,
          cancelBtnText: 'Cancelar',
          confirmBtnText: action,
          confirmBtnColor: action == 'Inativar' ? Colors.red : Colors.green,
          showCancelBtn: true,
          onConfirmBtnTap: () async {
            try {
              await _userController.changeUserState(user: user);
              Navigator.of(context).pop();
              CustomSnackBar(
                message:
                    'Sucesso ao ${action.toLowerCase()} usuário ${user.name}!',
                colorBar: Colors.green,
              );
            } catch (e) {
              CustomSnackBar(
                message: 'Erro ao ${action.toLowerCase()} usuário: $e!',
                colorBar: Colors.red,
              );
            }
          },
        );
      },
      icon: Icon(
        user.active ? Icons.no_accounts : Icons.check_circle_outline,
        color: user.active ? Colors.red : Colors.green,
      ),
    );
  }
}
