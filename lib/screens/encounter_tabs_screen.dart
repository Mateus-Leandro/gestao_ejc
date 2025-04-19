import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestao_ejc/components/utils/custom_tab_bar.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/screens/circle_tabs_screen.dart';
import 'package:gestao_ejc/screens/encounter_info_screen.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/screens/team_tabs_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class EncounterTabsScreen extends StatelessWidget {
  final EncounterModel encounterModel;

  EncounterTabsScreen({super.key, required this.encounterModel});

  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
  final AppTheme appTheme = getIt<AppTheme>();
  final List<Tab> tabs = const [
    Tab(
      icon: FaIcon(FontAwesomeIcons.gear, color: Colors.blue),
      text: 'Info',
    ),
    Tab(
      icon: FaIcon(FontAwesomeIcons.solidCircle, color: Colors.orange),
      text: 'Círculos',
    ),
    Tab(
      icon: FaIcon(FontAwesomeIcons.peopleGroup, color: Colors.green),
      text: 'Equipes',
    ),
    Tab(
      icon: Icon(FontAwesomeIcons.microphone, color: Colors.red),
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
                  _KeepAliveWrapper(
                    child: EncounterInfoScreen(
                        encounterModel: encounterModel, newEncounter: false),
                  ),
                  _KeepAliveWrapper(
                    child: CircleTabsScreen(
                      encounterModel: encounterModel,
                    ),
                  ),
                  _KeepAliveWrapper(
                    child: TeamTabsScreen(encounter: encounterModel),
                  ),
                  _KeepAliveWrapper(child: Container()),
                ],
              ),
              tabLenght: tabs.length,
            ),
          ),
        ],
      ),
      indexMenuSelected: null,
      showMenuDrawer: false,
    );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
