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

    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            children: [
              CustomFirestoreImage(imagePath: "images/app/roses/rosa02.png"),
            ],
          ),
          Column(
            children: [
              ListTile(
                  selectedTileColor: selectedTileColor,
                  selectedColor: textColor,
                  textColor: textColor,
                  tileColor: tileColor,
                  hoverColor: selectedTileColor,
                  title: const Text('Encontros'),
                  selected: indexMenuSelected == 0,
                  onTap: () {
                    callScreen(context, '/encounters', 0);
                  }),
              ListTile(
                  selectedTileColor: selectedTileColor,
                  selectedColor: textColor,
                  textColor: textColor,
                  tileColor: tileColor,
                  hoverColor: selectedTileColor,
                  title: const Text('Circulos'),
                  selected: indexMenuSelected == 1,
                  onTap: () {
                    callScreen(context, '/circles', 1);
                  }),
              ListTile(
                  selectedTileColor: selectedTileColor,
                  selectedColor: textColor,
                  textColor: textColor,
                  tileColor: tileColor,
                  hoverColor: selectedTileColor,
                  title: const Text('Membros'),
                  selected: indexMenuSelected == 2,
                  onTap: () {
                    callScreen(context, '/members', 2);
                  }),
              ListTile(
                  selectedTileColor: selectedTileColor,
                  selectedColor: textColor,
                  textColor: textColor,
                  tileColor: tileColor,
                  hoverColor: selectedTileColor,
                  title: const Text('Exportação'),
                  selected: indexMenuSelected == 3,
                  onTap: () {
                    callScreen(context, '/export', 3);
                  }),
              ListTile(
                  selectedTileColor: selectedTileColor,
                  selectedColor: textColor,
                  textColor: textColor,
                  tileColor: tileColor,
                  hoverColor: selectedTileColor,
                  title: const Text('Importação'),
                  selected: indexMenuSelected == 4,
                  onTap: () {
                    callScreen(context, '/import', 4);
                  }),
              ListTile(
                  selectedTileColor: selectedTileColor,
                  selectedColor: textColor,
                  textColor: textColor,
                  tileColor: tileColor,
                  hoverColor: selectedTileColor,
                  title: const Text('Financeiro'),
                  selected: indexMenuSelected == 5,
                  onTap: () {
                    callScreen(context, '/financial', 5);
                  }),
              ListTile(
                selectedTileColor: selectedTileColor,
                selectedColor: textColor,
                textColor: textColor,
                tileColor: tileColor,
                hoverColor: selectedTileColor,
                title: const Text('Cadastro de Usuarios'),
                selected: indexMenuSelected == 6,
                onTap: () {
                  callScreen(context, '/users', 6);
                },
              ),
              ListTile(
                tileColor: tileColor,
                selectedColor: textColor,
                textColor: Colors.white,
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
        ],
      ),
    );
  }

  void callScreen(BuildContext context, String rout, int indexMenu) {
    if (indexMenuSelected != indexMenu) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, rout);
    }
  }
}
