import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/user_form.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/models/userModel.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _userController = getIt<UserController>();

  @override
  void initState() {
    _userController.init();
    super.initState();
  }

  @override
  void dispose() {
    _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      title: 'Usuários',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: 15),
                Expanded(child: _buildUserList(context)),
              ],
            ),
          ),
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
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 30),
            child: _SearchField(),
          ),
        )
      ],
    );
  }

  Widget _buildUserList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: StreamBuilder<List<UserModel>>(
        stream: _userController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar usuários: ${snapshot.error}'));
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
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, UserModel user) {
    return ListTile(
      title: Text(
        user.name,
        style: TextStyle(
          color: user.activeUser
              ? (user.manipulateAdministrator ? Colors.blue : Colors.black)
              : Colors.red,
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
            message: 'Inativar usuário',
            child: IconButton(
              onPressed: () => _onDeactivateUserPressed(user),
              icon: const Icon(
                Icons.no_accounts,
                color: Colors.red,
              ),
            ),
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

  void _onDeactivateUserPressed(UserModel user) {
    // TODO: Lógica para inativar o usuário
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      keyboardType: TextInputType.name,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Pesquisar usuários',
        icon: Icon(Icons.search_outlined),
        iconColor: Colors.white,
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
    );
  }
}
