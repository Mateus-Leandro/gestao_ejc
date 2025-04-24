import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/screens/team_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class TeamTabsScreen extends StatelessWidget {
  final EncounterModel encounter;

  TeamTabsScreen({super.key, required this.encounter});

  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
  final AppTheme appTheme = getIt<AppTheme>();
  final List<Tab> tabs = const [
    Tab(
      icon: FaIcon(FontAwesomeIcons.pencil, color: Colors.black),
      text: 'Cadastro',
    ),
    Tab(
      icon: FaIcon(FontAwesomeIcons.peopleLine, color: Colors.purple),
      text: 'Membros',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ButtonsTabBar(
              backgroundColor: appTheme.colorBackgroundTabBar,
              tabs: tabs,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _KeepAliveWrapper(
                    child: TeamScreen(encounter: encounter),
                  ),
                  _KeepAliveWrapper(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
