import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOfBirthField extends StatefulWidget {
  final TextEditingController controller;

  const DateOfBirthField({Key? key, required this.controller}) : super(key: key);

  @override
  _DateOfBirthFieldState createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends State<DateOfBirthField> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('pt', 'BR')
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = DateFormat('dd/MM/yyyy', 'pt_BR').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Data de Nascimento',
        border: OutlineInputBorder(),
      ),
      onTap: () => _selectDate(context),
    );
  }
}
