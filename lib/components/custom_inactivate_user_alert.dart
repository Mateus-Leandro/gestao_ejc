import 'package:flutter/material.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CustomInactivateUserAlert extends StatelessWidget {
  const CustomInactivateUserAlert({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final UserController _userController = getIt<UserController>();
    final AppTheme _appTheme = getIt<AppTheme>();
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
            String? result = await _userController.changeUserState(user: user);
            Navigator.of(context).pop();
            if (result == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Sucesso ao ${action.toLowerCase()} usuário ${user.name}!'),
                    backgroundColor: _appTheme.colorSnackBarSucess),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Erro: $result'),
                    backgroundColor: _appTheme.colorSnackBarErro),
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
