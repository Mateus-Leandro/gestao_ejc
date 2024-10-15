import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_inactivate_user_alert.dart';
import 'package:gestao_ejc/components/custom_row_add_and_search.dart';
import 'package:gestao_ejc/components/custom_user_form.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _userController = getIt<UserController>();
  final _appTheme = getIt<AppTheme>();
  final AuthService _authService = getIt<AuthService>();

  Timer? delay;
  Timer? debounce;
  final TextEditingController userNameController = TextEditingController();

  @override
  void initState() {
    _userController.init();
    super.initState();
  }

  @override
  void dispose() {
    _userController.dispose();
    delay?.cancel();
    debounce?.cancel();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      title: 'Usuários',
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomRowAddAndSearch(
              messageButton: 'Novo Usuário',
              functionButton: () => _showUserForm(null),
              inputType: TextInputType.text,
              controller: userNameController,
              messageTextField: 'Nome Usuário',
              functionTextField: () => _userController.getUsers(
                userNameController.text.trim().isEmpty
                    ? null
                    : userNameController.text.trim(),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(child: _buildUserList(context)),
          ],
        ),
      ),
      indexMenuSelected: 6,
    );
  }

  Widget _buildUserList(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: _userController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar usuários: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum usuário encontrado.'));
        }

        var users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            return _buildUserTile(context, user);
          },
        );
      },
    );
  }

  Widget _buildUserTile(BuildContext context, UserModel user) {
    return ListTile(
      title: Text(
        user.name,
        style: TextStyle(
          color: user.active
              ? (user.manipulateAdministrator ? Colors.blue : Colors.black)
              : _appTheme.colorInativeUser,
        ),
      ),
      subtitle: Text(user.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_authService.actualUserModel?.manipulateAdministrator ?? false) ...[
            Tooltip(
              message: 'Editar',
              child: IconButton(
                onPressed: () => _showUserForm(user),
                icon: const Icon(Icons.edit),
              ),
            ),
            Tooltip(
              message: user.active ? 'Inativar usuário' : 'Ativar usuário',
              child: CustomInactivateUserAlert(user: user),
            ),
          ],
        ],
      ),
    );
  }

  void _showUserForm(UserModel? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomUserForm(userEditing: user);
      },
    );
  }
}
