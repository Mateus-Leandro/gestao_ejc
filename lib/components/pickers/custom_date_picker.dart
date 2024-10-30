import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime? lowestDate;
  final DateTime? higherDate;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.labelText,
    this.lowestDate,
    this.higherDate,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final FunctionDate functionDate = getIt<FunctionDate>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openDatePickerDialog,
      child: AbsorbPointer(
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Necessário informar a data';
            }
            return null;
          },
        ),
      ),
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
