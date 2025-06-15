import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

Future<bool> showAlreadyLinkedDialog({
  required BuildContext context,
  required String actualTeam,
  required String destinationTeam,
}) async {
  bool confirmed = false;

  await QuickAlert.show(
    context: context,
    type: QuickAlertType.warning,
    title: 'O membro selecionado já está vinculado ${actualTeam}!',
    text: 'Deseja deseja movê-lo para $destinationTeam?',
    animType: QuickAlertAnimType.slideInUp,
    showCancelBtn: true,
    confirmBtnText: 'Sim',
    cancelBtnText: 'Não',
    confirmBtnColor: Colors.green,
    onConfirmBtnTap: () {
      confirmed = true;
      Navigator.of(context).pop();
    },
    onCancelBtnTap: () {
      confirmed = false;
      Navigator.of(context).pop();
    },
  );

  return confirmed;
}
