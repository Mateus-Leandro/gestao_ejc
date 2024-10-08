import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/date_of_birth_field.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key, this.userEditing});

  final UserModel? userEditing;

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
  final _appTheme = getIt<AppTheme>();
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
  void initState() {
    super.initState();
    if (widget.userEditing != null) {
      _nameController.text = widget.userEditing!.name ?? '';
      _emailController.text = widget.userEditing!.email ?? '';
      _birthdayController.text = widget.userEditing!.birthday ?? '';
      _passwordController.text = "***********";
      _confirmePasswordController.text = "***********";
      manipulateAdministrator = widget.userEditing!.manipulateAdministrator;
      manipulateCircles = widget.userEditing!.manipulateCircles;
      manipulateEncounter = widget.userEditing!.manipulateEncounter;
      manipulateExport = widget.userEditing!.manipulateExport;
      manipulateFinancial = widget.userEditing!.manipulateFinancial;
      manipulateImport = widget.userEditing!.manipulateImport;
      manipulateMembers = widget.userEditing!.manipulateMembers;
      manipulateUsers = widget.userEditing!.manipulateUsers;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmePasswordController.dispose();
    _birthdayController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(widget.userEditing == null
          ? 'Adicionar Novo Usuário'
          : 'Editar Usuário'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(false, _nameController, 'Nome',
                  TextInputType.text, null, true),
              const SizedBox(height: 10),
              DateOfBirthField(controller: _birthdayController),
              const SizedBox(height: 10),
              _buildTextField(false, _emailController, 'Email',
                  TextInputType.emailAddress, null, widget.userEditing == null),
              const SizedBox(height: 10),
              _buildTextField(true, _passwordController, 'Senha',
                  TextInputType.text, null, widget.userEditing == null),
              const SizedBox(height: 10),
              _buildTextField(
                  true,
                  _confirmePasswordController,
                  'Confirme a senha',
                  TextInputType.text,
                  _validatePassword,
                  widget.userEditing == null),
              const Text('Permissões', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              _buildPermissionCheckboxes(),
            ],
          ),
        ),
      ),
      actions: _savingUser
          ? [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
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
      FormFieldValidator<String>? validatorFunction,
      bool enabled) {
    return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a senha';
    }
    if (_passwordController.text != _confirmePasswordController.text) {
      return 'Senha informada diferente da anterior';
    }
    return null;
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savingUser = true;
      });

      UserModel newUser = UserModel(
        active: true,
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
        id: widget.userEditing?.id ?? '',
      );

      String? password =
          widget.userEditing == null ? _passwordController.text.trim() : null;

      String? result = await _userController.saveUser(
        newUser: newUser,
        password: password,
      );

      setState(() {
        _savingUser = false;
      });

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Usuário ${newUser.name} ${widget.userEditing == null ? 'cadastrado' : 'atualizado'} com sucesso!'),
              backgroundColor: _appTheme.colorSnackBarSucess),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro: $result'),
              backgroundColor: _appTheme.colorSnackBarErro),
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
