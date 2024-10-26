import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_financial_tab_bar.dart';
import 'package:gestao_ejc/controllers/financial_index_controller.dart';
import 'package:gestao_ejc/functions/function_mask_decimal.dart';
import 'package:gestao_ejc/models/financial_index_model.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  final FinancialIndexController financialIndexController =
      getIt<FinancialIndexController>();
  final FunctionMaskDecimal functionMaskDecimal = getIt<FunctionMaskDecimal>();

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
      indexMenuSelected: 5,
      body: Column(
        children: [
          _buildFinancialSummaryStream(),
          const SizedBox(height: 16),
          const Expanded(child: CustomFinancialTabBar()),
        ],
      ),
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
