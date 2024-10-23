import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_delete_button.dart';
import 'package:gestao_ejc/components/custom_financial_form.dart';
import 'package:gestao_ejc/components/custom_list_tile.dart';
import 'package:gestao_ejc/components/custom_search_row.dart';
import 'package:gestao_ejc/components/custom_xlsx_financial_form.dart';
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
    numberTransactionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FinancialController financialController =
        getIt<FinancialController>();

    String? type = widget.transactionType;
    String? doc;
    return Column(
      children: [
        CustomSearchRow(
          messageButton: widget.transactionType == null
              ? 'Exportar Extrato'
              : 'Adicionar Lançamento',
          functionButton: () {
            if (widget.transactionType != null) {
              _showFinancialForm(null);
            } else {
              _showXlsxForm();
            }
          },
          showButton: true,
          iconButton: widget.transactionType == null
              ? const Icon(Icons.description_outlined)
              : const Icon(Icons.add),
          buttonColor: widget.transactionType == null ? Colors.green : null,
          inputType: TextInputType.text,
          controller: numberTransactionController,
          messageTextField: 'Nº do lançamento',
          functionTextField: () {
            doc = null;
            if (numberTransactionController.text.trim().isNotEmpty) {
              doc = numberTransactionController.text.trim();
            }
            financialController.getFinancial(
                transactionNumber: doc, transactionType: type);
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: StreamBuilder<List<FinancialModel>>(
              stream: financialController.stream,
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
    final FunctionMaskDecimal functionMaskDecimal =
        getIt<FunctionMaskDecimal>();

    return CustomListTile(
        listTile: ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  '${doc.type}${doc.numberTransaction} - ${doc.originOrDestination}',
                  style: TextStyle(
                    color: doc.type == "S" ? Colors.red : Colors.green,
                  ),
                ),
              ),
              if (widget.transactionType != null) ...[
                Tooltip(
                  message: 'Editar Lançamento',
                  child: IconButton(
                    onPressed: () {
                      _showFinancialForm(doc);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                Tooltip(
                  message: 'Excluir Lançamento',
                  child: CustomDeleteButton(
                    alertMessage: 'Excluir lançamento?',
                    deleteFunction: () async =>
                        await _financialController.deleteFinancial(
                      financialModel: doc,
                    ),
                  ),
                ),
              ],
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(doc.description),
              ),
              Text(
                functionMaskDecimal.formatValue(doc.value),
                style: TextStyle(
                  fontSize: 20,
                  color: doc.type == "S" ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
        defaultBackgroundColor: Colors.white);
  }

  void _showFinancialForm(FinancialModel? financialModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomFinancialForm(
            financialModel: financialModel,
            transactionType: widget.transactionType!);
      },
    );
  }

  void _showXlsxForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomXlsxFinancialForm();
      },
    );
  }
}
