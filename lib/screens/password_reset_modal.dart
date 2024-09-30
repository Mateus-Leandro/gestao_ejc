import 'package:flutter/material.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class PasswordResetModal extends StatefulWidget {
  const PasswordResetModal({super.key});

  @override
  State<PasswordResetModal> createState() => _PasswordResetModalState();
}

class _PasswordResetModalState extends State<PasswordResetModal> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final AuthService _authService = getIt<AuthService>();
  String? erro_message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Redefinir senha'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Endereço de e-mail'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe um endereço de email válido.';
            }
            return null;
          },
        ),
      ),
      actions: <TextButton>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _authService.resetPassword(email: _emailController.text).then(
                (String? erro) {
                  Navigator.of(context).pop();

                  if (erro != null) {
                    final snackBar = SnackBar(
                        content: Text(erro), backgroundColor: Colors.red);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                        content: Text(
                            'Um link de redefinição de senha foi enviado para seu email.'),
                        backgroundColor: Colors.green);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              );
            }
            ;
          },
          child: Text('Confirmar.'),
        )
      ],
    );
  }
}
