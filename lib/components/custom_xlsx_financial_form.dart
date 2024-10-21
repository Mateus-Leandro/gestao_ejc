import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_text_form_field.dart';
import 'package:gestao_ejc/controllers/financial_controller.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/financial_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CustomXlsxFinancialForm extends StatefulWidget {
  const CustomXlsxFinancialForm({super.key});

  @override
  State<CustomXlsxFinancialForm> createState() =>
      _CustomXlsxFinancialFormState();
}

class _CustomXlsxFinancialFormState extends State<CustomXlsxFinancialForm> {
  final TextEditingController _fileNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FinancialService financialService = getIt<FinancialService>();
  final FunctionDate functionDate = getIt<FunctionDate>();
  List<DateTime?> dates = [null, null];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Exportar Extrato'),
          Divider(),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _fileNameController,
                decoration: const InputDecoration(labelText: 'Nome do arquivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do arquivo a ser salvo.';
                  }
                  return null;
                },
                obscure: false,
                maxLength: 15,
                capitalizeFirstLetter: false,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text('Período dos lançamentos'),
              ),
              SizedBox(
                height: 330,
                width: 310,
                child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.range,
                      lastDate: DateTime.now(),
                      allowSameValueSelection: true,
                    ),
                    value: dates,
                    onValueChanged: (newDates) => dates = newDates),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (dates[0] != null && dates.length < 2) {
                dates.add(dates[0]);
              }

              if (dates[1] != null) {
                dates[1] = dates[1]!
                    .add(const Duration(hours: 23, minutes: 59, seconds: 59));
              }

              List<DateTime> rangeDates = [dates[0]!, dates[1]!];

              await generateDoc(rangeDates);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Exportar'),
        ),
      ],
    );
  }

  Future<void> generateDoc(List<DateTime> dates) async {
    List<FinancialModel> docs =
        await financialService.getFinancial(rangeDates: dates);
    FinancialController financialController = getIt<FinancialController>();
    await financialController.generateXlsx(
        docs, _fileNameController.text.trim());
  }
}
