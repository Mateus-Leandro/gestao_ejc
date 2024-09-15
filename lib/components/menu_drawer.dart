import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final Color tileColor = Theme.of(context).primaryColor;
    final FirebaseAuth firebaseAuth = getIt<FirebaseAuth>();
    final User user = firebaseAuth.currentUser!;

    return Drawer(
      backgroundColor: Colors.lightBlueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListTile(
                selectedTileColor: Colors.red,
                tileColor: tileColor,
                textColor: Colors.white,
                title: const Text('Encontros'),
                onTap: () {},
              ),
              ListTile(
                tileColor: tileColor,
                textColor: Colors.white,
                title: const Text('Circulos'),
                onTap: () {},
              ),
              ListTile(
                tileColor: tileColor,
                textColor: Colors.white,
                title: const Text('Membros'),
                onTap: () {},
              ),
              ListTile(
                tileColor: tileColor,
                textColor: Colors.white,
                title: const Text('Exportação'),
                onTap: () {},
              ),
              ListTile(
                tileColor: tileColor,
                textColor: Colors.white,
                title: const Text('Importação'),
                onTap: () {},
              ),
              ListTile(
                tileColor: tileColor,
                textColor: Colors.white,
                title: const Text('Financeiro'),
                onTap: () {},
              ),
            ],
          ),
          Column(
            children: [
              ListTile(
                tileColor: tileColor,
                textColor: Colors.white,
                title: const Text('Cadastro de Usuarios'),
                onTap: () {},
              ),
              SizedBox(
                height: 170,
                child: UserAccountsDrawerHeader(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.indigo,
                    ),
                  ),
                  accountName: Text(user.displayName ?? ''),
                  accountEmail: Text(user.email!),
                  margin: EdgeInsets.zero,
                ),
              ),
              ListTile(
                tileColor: tileColor,
                textColor: Colors.white,
                title: const Text('Sair'),
                onTap: () {
                  firebaseAuth.signOut();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
