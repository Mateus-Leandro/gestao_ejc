import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/financial_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/pdf_service.dart';
import 'package:gestao_ejc/services/xlsx_service.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomFinancialReportForm extends StatefulWidget {
  const CustomFinancialReportForm({super.key});

  @override
  State<CustomFinancialReportForm> createState() =>
      _CustomFinancialReportFormState();
}

class _CustomFinancialReportFormState extends State<CustomFinancialReportForm> {
  final TextEditingController _fileNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FinancialService financialService = getIt<FinancialService>();
  final FunctionDate functionDate = getIt<FunctionDate>();
  String? typeExport;
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
              TextFormField(
                controller: _fileNameController,
                decoration: const InputDecoration(labelText: 'Nome do arquivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do arquivo a ser salvo.';
                  }
                  return null;
                },
                maxLength: 15,
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
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Exportar arquivo em'),
              ),
              ToggleSwitch(
                minWidth: 90.0,
                initialLabelIndex: 0,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const ['Excel', 'PDF'],
                icons: const [Icons.file_copy, Icons.picture_as_pdf],
                activeBgColors: const [
                  [Colors.green],
                  [Colors.red]
                ],
                onToggle: (index) {
                  typeExport = index == 0 ? 'excel' : 'pdf';
                },
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

              await generateDoc(
                  dates: rangeDates, typeExport: typeExport ?? 'excel');
              Navigator.of(context).pop();
            }
          },
          child: const Text('Exportar'),
        ),
      ],
    );
  }

  Future<void> generateDoc(
      {required List<DateTime> dates, required String typeExport}) async {
    final PdfService pdfService = getIt<PdfService>();
    final XlsxService xlsxService = getIt<XlsxService>();

    List<FinancialModel> docs =
        await financialService.getFinancial(rangeDates: dates);

    List<String> interval =
        dates.map((date) => functionDate.getDateToString(date)).toList();

    typeExport == 'pdf'
        ? await pdfService.generateFinancialPdf(
            docs: docs,
            fileName: _fileNameController.text.trim(),
            interval: interval)
        : await xlsxService.generateFinancialXlsx(
            docs: docs, fileName: _fileNameController.text.trim());
  }
}
