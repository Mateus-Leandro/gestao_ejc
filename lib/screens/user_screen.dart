import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_inactivate_user_alert.dart';
import 'package:gestao_ejc/components/user_form.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
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
  Timer? delay;

  @override
  void initState() {
    _userController.init();
    super.initState();
  }

  @override
  void dispose() {
    _userController.dispose();
    delay?.cancel();
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
            _buildTopBar(context),
            const SizedBox(height: 15),
            Expanded(child: _buildUserList(context)),
          ],
        ),
      ),
      indexMenuSelected: 6,
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          message: 'Novo usuário',
          child: IconButton(
            onPressed: () {
              _showUserForm(null);
            },
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              backgroundColor: _appTheme.colorBackgroundButton,
              foregroundColor: _appTheme.colorForegroundButton,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: _buildSearchField(),
          ),
        ),
      ],
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
      ),
    );
  }

  void _showUserForm(UserModel? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserForm(userEditing: user);
      },
    );
  }

  Widget _buildSearchField() {
    final TextEditingController userNameController = TextEditingController();
    Timer? debounce;
    final appTheme = getIt<AppTheme>();

    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          keyboardType: TextInputType.name,
          style: TextStyle(color: appTheme.colorBackgroundButton),
          controller: userNameController,
          decoration: InputDecoration(
            hintText: 'Pesquisar usuários',
            icon: Icon(Icons.search_outlined,
                color: Theme.of(context).primaryColor),
            border: InputBorder.none,
          ),
          onChanged: (text) {
            if (debounce?.isActive ?? false) {
              debounce!.cancel();
            }
            debounce = Timer(const Duration(milliseconds: 500), () {
              _getUserByName(text.trim());
            });
          },
        );
      },
    );
  }

  void _getUserByName(String userName) {
    if (userName.isNotEmpty) {
      _userController.getUsers(userName);
    } else {
      _userController.getUsers(null);
    }
  }
}
