import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime? lowestDate;
  final DateTime? higherDate;
  final bool? active;
  final bool? readOnly;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.labelText,
    this.lowestDate,
    this.higherDate,
    this.active,
    this.readOnly,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final FunctionDate functionDate = getIt<FunctionDate>();

  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      inputFormatters: [maskFormatter],
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: widget.active != false && widget.readOnly != true
              ? _openDatePickerDialog
              : null,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Necessário informar a data';
        }
        if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
          return 'Data inválida';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      enabled: widget.active ?? true,
    );
  }

  Future<void> _openDatePickerDialog() async {
    List<DateTime?> selectedDate = [];
    String stringDate = widget.controller.text.trim();
    if (stringDate.isNotEmpty) {
      selectedDate.add(functionDate.getDateFromStringFormatted(stringDate));
    }

    final selectedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        firstDate: widget.lowestDate,
        lastDate: widget.higherDate,
      ),
      dialogSize: const Size(325, 400),
      value: selectedDate,
    );

    if (selectedDates != null && selectedDates.isNotEmpty) {
      setState(() {
        widget.controller.text =
            functionDate.getDateToString(selectedDates[0]!);
      });
    }
  }
}
