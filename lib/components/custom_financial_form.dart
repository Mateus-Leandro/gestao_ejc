import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:gestao_ejc/components/custom_date_picker.dart';
import 'package:gestao_ejc/components/custom_text_form_field.dart';
import 'package:gestao_ejc/controllers/financial_controller.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class CustomFinancialForm extends StatefulWidget {
  final FinancialModel? financialModel;
  final String transactionType;

  const CustomFinancialForm(
      {super.key, this.financialModel, required this.transactionType});

  @override
  State<CustomFinancialForm> createState() => _CustomFinancialFormState();
}

class _CustomFinancialFormState extends State<CustomFinancialForm> {
  bool _savingFinancial = false;
  final _appTheme = getIt<AppTheme>();
  final _financialController = getIt<FinancialController>();
  final _currentUser = getIt<FirebaseAuth>().currentUser;
  final _formKey = GlobalKey<FormState>();
  final _originOrDestinationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _transactionDateController = TextEditingController();
  final _valueController = CurrencyTextFieldController(
      enableNegative: false,
      currencySymbol: "R\$",
      decimalSymbol: ",",
      thousandSymbol: ".");

  late bool editing;
  late String originOrDestination;

  @override
  void initState() {
    super.initState();
    editing = widget.financialModel == null ? false : true;
    originOrDestination = widget.transactionType == "E" ? 'Origem' : 'Destino';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          Text(editing ? 'Editar Financeiro' : 'Criar Financeiro'),
          const Divider()
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (editing) ...[
                Text(
                  'Lançamento criado em: ${widget.financialModel?.registrationDate}',
                ),
                Text(
                  'por: ${widget.financialModel?.registrationUserId}',
                ),
              ],
              CustomTextFormField(
                  controller: _originOrDestinationController,
                  decoration: InputDecoration(labelText: originOrDestination),
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Informe ${widget.transactionType == 'E' ? 'a origem' : 'o destino'} do lançamento.'
                        : null;
                  },
                  obscure: false),
              CustomTextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Informe a decrição do lançamento'
                        : null;
                  },
                  obscure: false),
              CustomTextFormField(
                  controller: _valueController,
                  decoration: const InputDecoration(labelText: 'Valor'),
                  validator: (value) {
                    return _valueController.doubleValue == 0
                        ? 'Informe o valor do lançamento'
                        : null;
                  },
                  obscure: false),
              CustomDatePicker(
                controller: _transactionDateController,
                labelText: 'Data do lançamento',
                lowestDate: DateTime.now().subtract(const Duration(days: 7)),
              ),
            ],
          ),
        ),
      ),
      actions: _savingFinancial
          ? [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(),
                ),
              )
            ]
          : [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: _saveFinancial,
                child: const Text('Salvar'),
              ),
            ],
    );
  }

  void _saveFinancial() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savingFinancial = true;
      });
      FinancialModel financialModel = FinancialModel(
          type: widget.transactionType,
          value: _valueController.doubleValue,
          description: _descriptionController.text.trim(),
          originOrDestination: _originOrDestinationController.text.trim(),
          transactionDate: _transactionDateController.text.trim(),
          registrationDate: DateTime.now().toString(),
          registrationUserId: _currentUser!.uid);

      int? result = await _financialController.saveFinancial(
          financialModel: financialModel);

      setState(() {
        _savingFinancial = false;
      });

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Lançamento ${financialModel.type}$result ${editing ? 'atualizado' : 'cadastrado'} com sucesso!'),
              backgroundColor: _appTheme.colorSnackBarSucess),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao salvar lançamento: $result'),
              backgroundColor: _appTheme.colorSnackBarErro),
        );
      }
    }
  }
}
