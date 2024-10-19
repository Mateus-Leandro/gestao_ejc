import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_financial_form.dart';
import 'package:gestao_ejc/components/custom_row_add_and_search.dart';
import 'package:gestao_ejc/controllers/financial_controller.dart';
import 'package:gestao_ejc/functions/function_mask_decimal.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialDocsScreen extends StatefulWidget {
  final String? transactionType;

  const FinancialDocsScreen({super.key, required this.transactionType});

  @override
  State<FinancialDocsScreen> createState() => _FinancialDocsScreenState();
}

class _FinancialDocsScreenState extends State<FinancialDocsScreen> {
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
    final FinancialController _financialController =
        getIt<FinancialController>();

    String? type = widget.transactionType;
    String? doc;
    return Column(
      children: [
        CustomRowAddAndSearch(
          messageButton: 'Adicionar Lançamento',
          functionButton: () {
            _showFinancialForm(null);
          },
          showAddButton: widget.transactionType != null,
          inputType: TextInputType.text,
          controller: numberTransactionController,
          messageTextField: 'Nº do lançamento',
          functionTextField: () {
            doc = null;
            if (numberTransactionController.text.trim().isNotEmpty) {
              doc = numberTransactionController.text.trim();
            }
            _financialController.getFinancial(
                transactionNumber: doc, transactionType: type);
          },
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

    textColor = doc.type == "S" ? Colors.red : Colors.green;
    textType = 'Documento: ${doc.type}${doc.numberTransaction}';
    return ListTile(
      title: Row(
        children: [
          Text(
            textType,
            style: TextStyle(
              color: doc.type == "S" ? Colors.red : Colors.green,
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                _showFinancialForm(doc);
              },
              icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete_forever))
        ],
      ),
    );
  }

  void _showFinancialForm(FinancialModel? financialModel) {
    String? type = financialModel?.type ?? widget.transactionType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomFinancialForm(
            financialModel: financialModel, transactionType: type!);
      },
    );
  }
}
