import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/date_of_birth_field.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/models/userModel.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmePasswordController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _userController = getIt<UserController>();
  final _formKey = GlobalKey<FormState>();

  bool manipulateAdministrator = false;
  bool manipulateCircles = false;
  bool manipulateEncounter = false;
  bool manipulateExport = false;
  bool manipulateFinancial = false;
  bool manipulateImport = false;
  bool manipulateMembers = false;
  bool manipulateUsers = false;

  bool _savingUser = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text('Adicionar Novo Usuário'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                  false, _nameController, 'Nome', TextInputType.text, null),
              const SizedBox(height: 10),
              DateOfBirthField(controller: _birthdayController),
              const SizedBox(height: 10),
              _buildTextField(false, _emailController, 'Email',
                  TextInputType.emailAddress, null),
              const SizedBox(height: 10),
              _buildTextField(
                  true, _passwordController, 'Senha', TextInputType.text, null),
              const SizedBox(height: 10),
              _buildTextField(
                  true,
                  _confirmePasswordController,
                  'Confirme a senha',
                  TextInputType.text,
                  (value) => _passwordController.text !=
                          _confirmePasswordController.text
                      ? 'Senha informada diferente da anterior'
                      : null),
              const Text('Permissões', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              _buildPermissionCheckboxes(),
            ],
          ),
        ),
      ),
      actions: _savingUser
          ? [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CircularProgressIndicator(),
          ),
        )
      ]
          : [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveUser,
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  Widget _buildTextField(
      bool obscureText,
      TextEditingController controller,
      String label,
      TextInputType keyboardType,
      FormFieldValidator<String>? validatorFunction) {
    return TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validatorFunction ??
                (value) {
              return value!.isEmpty ? 'Informe o $label do usuário' : null;
            });
  }

  Widget _buildPermissionCheckboxes() {
    return Column(
      children: [
        _buildCheckbox('Administrador', manipulateAdministrator, (value) {
          setState(() {
            manipulateAdministrator = value!;
            manipulateCircles = manipulateEncounter = manipulateExport =
                manipulateFinancial = manipulateImport = manipulateMembers =
                manipulateUsers = manipulateAdministrator;
          });
        }),
        _buildCheckbox('Círculos', manipulateCircles, (value) {
          if (!manipulateAdministrator) {
            setState(() => manipulateCircles = value!);
          }
        }, disabled: manipulateAdministrator),
        _buildCheckbox('Encontros', manipulateEncounter, (value) {
          if (!manipulateAdministrator) {
            setState(() => manipulateEncounter = value!);
          }
        }, disabled: manipulateAdministrator),
        _buildCheckbox('Exportações', manipulateExport, (value) {
          if (!manipulateAdministrator) {
            setState(() => manipulateExport = value!);
          }
        }, disabled: manipulateAdministrator),
        _buildCheckbox('Financeiro', manipulateFinancial, (value) {
          if (!manipulateAdministrator) {
            setState(() => manipulateFinancial = value!);
          }
        }, disabled: manipulateAdministrator),
        _buildCheckbox('Importações', manipulateImport, (value) {
          if (!manipulateAdministrator) {
            setState(() => manipulateImport = value!);
          }
        }, disabled: manipulateAdministrator),
        _buildCheckbox('Membros', manipulateMembers, (value) {
          if (!manipulateAdministrator) {
            setState(() => manipulateMembers = value!);
          }
        }, disabled: manipulateAdministrator),
        _buildCheckbox('Usuários', manipulateUsers, (value) {
          if (!manipulateAdministrator) {
            setState(() => manipulateUsers = value!);
          }
        }, disabled: manipulateAdministrator),
      ],
    );
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savingUser = true;
      });

      UserModel newUser = UserModel(
          activeUser: true,
          birthday: _birthdayController.text.trim(),
          email: _emailController.text.trim(),
          manipulateAdministrator: manipulateAdministrator,
          manipulateCircles: manipulateCircles,
          manipulateEncounter: manipulateEncounter,
          manipulateExport: manipulateExport,
          manipulateFinancial: manipulateFinancial,
          manipulateImport: manipulateImport,
          manipulateMembers: manipulateMembers,
          manipulateUsers: manipulateUsers,
          name: _nameController.text.trim(),
          userId: '');

      String? result = await _userController.addUser(
          newUser: newUser, password: _passwordController.text.trim());

      setState(() {
        _savingUser = false;
      });

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Usuário ${newUser.name} cadastrado com sucesso!'),
              backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $result')),
        );
      }
    }
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged,
      {bool disabled = false}) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: disabled ? null : onChanged),
        Text(label),
      ],
    );
  }
}
