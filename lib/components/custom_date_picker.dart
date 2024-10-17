import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime? lowestDate;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.labelText,
    this.lowestDate,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.lowestDate ?? DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text =
            DateFormat('dd/MM/yyyy', 'pt_BR').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'A data não pode ser vazia';
        }
        return null;
      },
    );
  }
}
