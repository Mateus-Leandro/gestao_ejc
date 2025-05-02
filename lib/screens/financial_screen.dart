import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/utils/custom_tab_bar.dart';
import 'package:gestao_ejc/controllers/financial_index_controller.dart';
import 'package:gestao_ejc/functions/function_mask_decimal.dart';
import 'package:gestao_ejc/models/financial_index_model.dart';
import 'package:gestao_ejc/screens/financial_docs_screen.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  final FinancialIndexController financialIndexController =
      getIt<FinancialIndexController>();
  final FunctionMaskDecimal functionMaskDecimal = getIt<FunctionMaskDecimal>();
  final AppTheme appTheme = getIt<AppTheme>();

  @override
  void initState() {
    super.initState();
    financialIndexController.init();
  }

  @override
  void dispose() {
    super.dispose();
    financialIndexController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      title: 'Financeiro',
      indexMenuSelected: 4,
      body: Column(
        children: [
          _buildFinancialSummaryStream(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildFinancialTabBar(),
          ),
        ],
      ),
      showMenuDrawer: true,
    );
  }

  Widget _buildFinancialSummaryStream() {
    return StreamBuilder<FinancialIndexModel>(
      stream: financialIndexController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar Saldo: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Nenhum dado disponível'));
        }
        return _buildFinancialSummaryCard(snapshot.data!);
      },
    );
  }

  _buildFinancialTabBar() {
    return CustomTabBar(
      buttonsTabBar: ButtonsTabBar(
        backgroundColor: appTheme.colorBackgroundTabBar,
        tabs: const [
          Tab(
            icon: Icon(Icons.payments_outlined),
            text: 'Extrato',
          ),
          Tab(
            icon: Icon(Icons.arrow_downward, color: Colors.green),
            text: 'Entradas',
          ),
          Tab(
            icon: Icon(Icons.arrow_upward, color: Colors.red),
            text: 'Saídas',
          ),
        ],
      ),
      tabBarView: const TabBarView(
        children: [
          Center(child: FinancialDocsScreen(transactionType: null)),
          Center(child: FinancialDocsScreen(transactionType: "E")),
          Center(child: FinancialDocsScreen(transactionType: "S")),
        ],
      ), tabLenght: 3,
    );
  }

  Widget _buildFinancialSummaryCard(FinancialIndexModel data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSummaryText('Entradas',
                functionMaskDecimal.formatValue(data.totalInputValue)),
            _buildSummaryText('Saídas',
                functionMaskDecimal.formatValue(data.totalOutputValue)),
            _buildSummaryText(
                'Saldo',
                functionMaskDecimal
                    .formatValue(data.totalInputValue - data.totalOutputValue)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ],
    );
  }
}
