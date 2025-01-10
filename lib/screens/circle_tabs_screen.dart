import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/screens/circle_members_screen.dart';
import 'package:gestao_ejc/screens/circle_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class CircleTabsScreen extends StatelessWidget {
  final EncounterModel encounterModel;

  CircleTabsScreen({super.key, required this.encounterModel});

  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
  final AppTheme appTheme = getIt<AppTheme>();
  final List<Tab> tabs = const [
    Tab(
      icon: FaIcon(FontAwesomeIcons.pencil, color: Colors.black),
      text: 'Cadastro',
    ),
    Tab(
      icon: FaIcon(FontAwesomeIcons.question, color: Colors.red),
      text: 'Perguntas',
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
                  const _KeepAliveWrapper(
                    child: CircleScreen(),
                  ),
                  _KeepAliveWrapper(
                    child: Container(),
                  ),
                  const _KeepAliveWrapper(child: CircleMembersScreen()),
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
