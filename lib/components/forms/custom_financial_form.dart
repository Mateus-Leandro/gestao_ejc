import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:gestao_ejc/components/pickers/custom_date_picker.dart';
import 'package:gestao_ejc/controllers/financial_controller.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_input_text.dart';
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
  String? _createdBy;
  final _userController = getIt<UserController>();
  final _functionDate = getIt<FunctionDate>();
  final _firestore = getIt<FirebaseFirestore>();
  final _appTheme = getIt<AppTheme>();
  final _financialController = getIt<FinancialController>();
  final _currentUser = getIt<FirebaseAuth>().currentUser;
  final _formKey = GlobalKey<FormState>();
  final _originOrDestinationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _transactionDateController = TextEditingController();
  final FunctionInputText functionInputText = getIt<FunctionInputText>();
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
    if (editing) {
      _originOrDestinationController.text =
          widget.financialModel?.originOrDestination ?? '';
      _descriptionController.text = widget.financialModel?.description ?? '';
      _transactionDateController.text = _functionDate
          .getStringFromTimestamp(widget.financialModel!.transactionDate);
      _valueController.forceValue(
          initDoubleValue: widget.financialModel?.value ?? 0);
      _getNameUser();
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    if (editing) ...[
                      Expanded(
                        child: Text(
                            'Criado por ${_createdBy ?? ''} em ${_functionDate.getStringFromTimestamp(widget.financialModel!.registrationDate)}'),
                      ),
                    ],
                  ],
                ),
              ),
              TextFormField(
                controller: _originOrDestinationController,
                decoration: InputDecoration(labelText: originOrDestination),
                validator: (value) {
                  return value!.isEmpty
                      ? 'Informe ${widget.transactionType == 'E' ? 'a origem' : 'o destino'} do lançamento.'
                      : null;
                },
                maxLength: 15,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  functionInputText.capitalizeFirstLetter(
                      value: value, controller: _originOrDestinationController);
                },
              ),
              TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Informe a decrição do lançamento'
                        : null;
                  },
                  textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  functionInputText.capitalizeFirstLetter(
                      value: value, controller: _descriptionController);
                },),
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(labelText: 'Valor'),
                validator: (value) {
                  return _valueController.doubleValue == 0
                      ? 'Informe o valor do lançamento'
                      : null;
                },
              ),
              CustomDatePicker(
                controller: _transactionDateController,
                labelText: 'Data do lançamento',
                lowestDate: DateTime.now().subtract(
                  const Duration(days: 7),
                ),
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

      FinancialModel newFinancialModel = FinancialModel(
          numberTransaction:
              editing ? widget.financialModel!.numberTransaction! : null,
          type: widget.transactionType,
          value: _valueController.doubleValue,
          description: _descriptionController.text.trim(),
          originOrDestination: _originOrDestinationController.text.trim(),
          transactionDate: _functionDate
              .getTimestampFromString(_transactionDateController.text.trim()),
          registrationDate: editing
              ? widget.financialModel!.registrationDate
              : _functionDate.getTimestampFromString(null),
          registrationUser: editing
              ? widget.financialModel!.registrationUser
              : _firestore.doc('users/${_currentUser!.uid}'));
      int? result;

      if (editing) {
        result = await _financialController.updateFinancial(
            financialModel: widget.financialModel!,
            newFinancialModel: newFinancialModel);
      } else {
        result = await _financialController.createFinancial(
            financialModel: newFinancialModel);
      }

      setState(() {
        _savingFinancial = false;
      });

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Lançamento ${newFinancialModel.type}$result salvo com sucesso!'),
              backgroundColor: _appTheme.colorSnackBarSucess),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao salvar lançamento, tente novamente!'),
              backgroundColor: _appTheme.colorSnackBarErro),
        );
      }
    }
  }

  void _getNameUser() async {
    String? nameUser = await _userController.getNameByReferenceUser(
        referenceUser: widget.financialModel!.registrationUser!);
    setState(() {
      _createdBy = nameUser;
    });
  }
}
