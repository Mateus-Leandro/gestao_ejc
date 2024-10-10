import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_financial_tab_bar.dart';
import 'package:gestao_ejc/screens/model_screen.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  @override
  Widget build(BuildContext context) {
    return const ModelScreen(
      title: 'Financeiro',
      indexMenuSelected: 5,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: CustomFinancialTabBar(),
            ),
          ],
        ),
      ),
    );
  }
}
