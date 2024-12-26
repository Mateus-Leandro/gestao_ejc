import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/controllers/auth_controller.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class PasswordResetModal extends StatefulWidget {
  const PasswordResetModal({super.key});

  @override
  State<PasswordResetModal> createState() => _PasswordResetModalState();
}

class _PasswordResetModalState extends State<PasswordResetModal> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final AuthController _authController = getIt<AuthController>();
  String? erro_message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Redefinir senha'),
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
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              try {
                _authController.resetPassword(email: _emailController.text);
                CustomSnackBar.show(
                  context: context,
                  message:
                      'Enviado email de redefinição de senha para: ${_emailController.text}',
                  colorBar: Colors.green,
                );
              } catch (e) {
                CustomSnackBar.show(
                  context: context,
                  message: e.toString(),
                  colorBar: Colors.red,
                );
              }
            }
          },
          child: const Text('Confirmar.'),
        )
      ],
    );
  }
}
