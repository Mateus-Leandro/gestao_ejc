import 'package:flutter/material.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CustomDeleteButton extends StatelessWidget {
  final String alertMessage;
  final Future Function() deleteFunction;
  final Icon? iconButton;

  const CustomDeleteButton({
    super.key,
    required this.alertMessage,
    required this.deleteFunction,
    this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = getIt<AppTheme>();
    return IconButton(
      onPressed: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: alertMessage,
          text: 'Atenção! Não será possível recuperá-lo após a exclusão!',
          animType: QuickAlertAnimType.slideInLeft,
          cancelBtnText: 'Cancelar',
          confirmBtnText: 'Excluir',
          confirmBtnColor: Colors.red,
          showCancelBtn: true,
          onConfirmBtnTap: () async {
            Navigator.of(context).pop();

            String? result = await deleteFunction();

            if (result == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: const Text('Excluído com sucesso!'),
                    backgroundColor: appTheme.colorSnackBarSucess),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao realizar exclusão: $result'),
                  backgroundColor: appTheme.colorSnackBarErro,
                ),
              );
            }
          },
        );
      },
      icon: iconButton ??
          const Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
    );
  }
}
