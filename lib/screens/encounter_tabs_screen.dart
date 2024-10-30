import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/utils/custom_tab_bar.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/screens/encounter_info_screen.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class EncounterTabsScreen extends StatelessWidget {
  final EncounterModel encounterModel;

  EncounterTabsScreen({super.key, required this.encounterModel});

  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
  final AppTheme appTheme = getIt<AppTheme>();
  final List<Tab> tabs = const [
    Tab(
      icon: Icon(Icons.settings),
      text: 'Informações',
    ),
    Tab(
      icon: Icon(Icons.circle_outlined, color: Colors.orange),
      text: 'Circulos',
    ),
    Tab(
      icon: Icon(Icons.group, color: Colors.green),
      text: 'Equipes',
    ),
    Tab(
      icon: Icon(Icons.record_voice_over, color: Colors.red),
      text: 'Palestras',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
        title:
            '${functionIntToRoman.convert(encounterModel.sequential)} - EJC Céu Azul',
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CustomTabBar(
                  buttonsTabBar: ButtonsTabBar(
                    backgroundColor: appTheme.colorBackgroundTabBar,
                    tabs: tabs,
                  ),
                  tabBarView: TabBarView(
                    children: [
                      EncounterInfoScreen(encounterModel: encounterModel),
                      Container(),
                      Container(),
                      Container(),
                    ],
                  ),
                  tabLenght: tabs.length),
            )
          ],
        ),
        indexMenuSelected: null,
        showMenuDrawer: false);
  }
}
