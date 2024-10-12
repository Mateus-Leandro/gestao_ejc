import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_row_add_and_search.dart';
import 'package:gestao_ejc/controllers/financial_controller.dart';
import 'package:gestao_ejc/functions/function_mask_decimal.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialDocsScreen extends StatefulWidget {
  final int? transactionType;

  const FinancialDocsScreen({super.key, required this.transactionType});

  @override
  State<FinancialDocsScreen> createState() =>
      _FinancialDocsScreenState();
}

class _FinancialDocsScreenState
    extends State<FinancialDocsScreen> {
  final TextEditingController numberTransactionController =
      TextEditingController();
  final FinancialController _financialController = getIt<FinancialController>();

  @override
  void initState() {
    _financialController.init(transactionType: widget.transactionType);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomRowAddAndSearch(
          messageButton: 'Adicionar Lançamento',
          functionButton: () {},
          inputType: TextInputType.text,
          controller: numberTransactionController,
          messageTextField: 'Nº do lançamento',
          functionTextField: () {},
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: StreamBuilder<List<FinancialModel>>(
              stream: _financialController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child:
                        Text('Erro ao carregar Lançamentos: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum lançamento encontrado.'),
                  );
                }

                var financialDocs = snapshot.data!;
                return ListView.builder(
                  itemCount: financialDocs.length,
                  itemBuilder: (context, index) {
                    var doc = financialDocs[index];
                    return _buildUserTile(context, doc);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTile(BuildContext context, FinancialModel doc) {
    Color textColor;
    String textType;
    final FunctionMaskDecimal functionMaskDecimal =
        getIt<FunctionMaskDecimal>();

    if (doc.type == 1) {
      textColor = Colors.red;
      textType = 'SAÍDA';
    } else {
      textColor = Colors.green;
      textType = 'ENTRADA';
    }
    return ListTile(
      title: Row(
        children: [
          Text(
            textType,
            style: TextStyle(
              color: doc.type == 1 ? Colors.red : Colors.green,
            ),
          )
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(doc.description),
          ),
          Text(
            functionMaskDecimal.formatValue(doc.value),
            style: TextStyle(fontSize: 20, color: textColor),
          ),
        ],
      ),
      trailing: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        ],
      ),
    );
  }
}
