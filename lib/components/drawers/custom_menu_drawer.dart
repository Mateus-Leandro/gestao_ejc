import 'package:flutter/material.dart';
import 'package:gestao_ejc/functions/function_screen.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class CustomMenuDrawer extends StatelessWidget {
  const CustomMenuDrawer({super.key, required this.indexMenuSelected});

  final int? indexMenuSelected;

  @override
  Widget build(BuildContext context) {
    final FunctionScreen functionScreen = getIt<FunctionScreen>();
    final AppTheme appTheme = getIt<AppTheme>();
    final AuthService authService = getIt<AuthService>();

    final tileColor = appTheme.colorTile;
    final selectedTileColor = appTheme.colorFocusTile;
    final textColor = appTheme.colorLightText;

    final allMenuOptions = [
      {
        'title': 'Encontros',
        'route': '/encounter',
        'index': 0,
        'permission': authService.actualUserModel!.manipulateEncounter
      },
      {
        'title': 'Membros',
        'route': '/members',
        'index': 2,
        'permission': authService.actualUserModel!.manipulateMembers
      },
      {
        'title': 'Exportação',
        'route': '/export',
        'index': 3,
        'permission': authService.actualUserModel!.manipulateExport
      },
      {
        'title': 'Importação',
        'route': '/import',
        'index': 4,
        'permission': authService.actualUserModel!.manipulateImport
      },
      {
        'title': 'Financeiro',
        'route': '/financial',
        'index': 5,
        'permission': authService.actualUserModel!.manipulateFinancial
      },
      {
        'title': 'Cadastro de Usuários',
        'route': '/users',
        'index': 6,
        'permission': authService.actualUserModel!.manipulateUsers
      },
    ];

    final List<Map<String, dynamic>> userOptions =
        allMenuOptions.where((item) => item['permission'] == true).toList();

    return Drawer(
      backgroundColor: tileColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  functionScreen.call(
                    context: context,
                    route: "/",
                    indexMenu: null,
                    indexMenuSelected: indexMenuSelected,
                    popActualScreen: true,
                  );
                },
                child: const Tooltip(
                  message: "Página inicial",
                  child: Image(
                    image: AssetImage('assets/images/logos/logo07.png'),
                  ),
                ),
              ),
            ),
          ),
          for (var item in userOptions)
            ListTile(
              selectedTileColor: selectedTileColor,
              selectedColor: textColor,
              textColor: textColor,
              tileColor: tileColor,
              hoverColor: selectedTileColor,
              title: Text(item['title']),
              selected: indexMenuSelected == item['index'],
              onTap: () {
                functionScreen.call(
                  context: context,
                  route: item['route'],
                  indexMenu: item['index'],
                  indexMenuSelected: indexMenuSelected,
                  popActualScreen: true,
                );
              },
            ),
          const Spacer(),
          Divider(color: appTheme.colorDivider),
          ListTile(
            tileColor: tileColor,
            selectedColor: textColor,
            textColor: textColor,
            hoverColor: selectedTileColor,
            title: const Text('Sair'),
            onTap: () {
              functionScreen.callLogOut(context: context);
            },
          ),
        ],
      ),
    );
  }
}
