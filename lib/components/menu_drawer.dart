import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_firestore_image.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key, required this.indexMenuSelected});
  final int? indexMenuSelected;

  @override
  Widget build(BuildContext context) {
    final Color tileColor = Theme.of(context).primaryColor;
    const Color selectedTileColor = Colors.blue;
    const Color textColor = Colors.white;

    FirebaseAuth firebaseAuth = getIt<FirebaseAuth>();
    AuthService authService = getIt<AuthService>();
    final User user = firebaseAuth.currentUser!;

    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Encontros', 'route': '/encounters', 'index': 0},
      {'title': 'Círculos', 'route': '/circles', 'index': 1},
      {'title': 'Membros', 'route': '/members', 'index': 2},
      {'title': 'Exportação', 'route': '/export', 'index': 3},
      {'title': 'Importação', 'route': '/import', 'index': 4},
      {'title': 'Financeiro', 'route': '/financial', 'index': 5},
      {'title': 'Cadastro de Usuários', 'route': '/users', 'index': 6},
    ];

    return Drawer(
      backgroundColor: tileColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: CustomFirestoreImage(
                imagePath: "images/app/logos/logo07.png",
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 7,
            child: ListView(
              children: [
                for (var item in menuItems)
                  ListTile(
                    selectedTileColor: selectedTileColor,
                    selectedColor: textColor,
                    textColor: textColor,
                    tileColor: tileColor,
                    hoverColor: selectedTileColor,
                    title: Text(item['title']),
                    selected: indexMenuSelected == item['index'],
                    onTap: () {
                      callScreen(context, item['route'], item['index']);
                    },
                  ),
                ListTile(
                  tileColor: tileColor,
                  selectedColor: textColor,
                  textColor: textColor,
                  hoverColor: selectedTileColor,
                  title: const Text('Sair'),
                  onTap: () {
                    authService.logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                          (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void callScreen(BuildContext context, String route, int indexMenu) {
    if (indexMenuSelected != indexMenu) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, route);
    }
  }
}
