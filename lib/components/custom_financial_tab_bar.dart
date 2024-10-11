import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:gestao_ejc/screens/financial_docs_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class CustomFinancialTabBar extends StatefulWidget {
  const CustomFinancialTabBar({super.key});

  @override
  State<CustomFinancialTabBar> createState() => _CustomFinancialTabBarState();
}

class _CustomFinancialTabBarState extends State<CustomFinancialTabBar> {
  @override
  Widget build(BuildContext context) {
    final appTheme = getIt<AppTheme>();
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          ButtonsTabBar(
            backgroundColor: appTheme.colorBackgroundTabBar,
            tabs: const [
              Tab(
                icon: Icon(Icons.arrow_downward, color: Colors.green),
                text: 'Entradas',
              ),
              Tab(
                icon: Icon(Icons.arrow_upward, color: Colors.red),
                text: 'Saídas',
              ),
              Tab(
                icon: Icon(Icons.payments_outlined),
                text: 'Extrato',
              ),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                Center(child: FinancialDocsScreen(transactionType: 2)),
                Center(child: FinancialDocsScreen(transactionType: 1)),
                Center(child: FinancialDocsScreen(transactionType: null)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
