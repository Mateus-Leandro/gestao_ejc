import 'package:flutter/material.dart';
import 'package:gestao_ejc/enums/instrument_enum.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CustomInstrumentDrawer extends StatefulWidget {
  final MultiSelectController<InstrumentEnum> instrumentController;
  const CustomInstrumentDrawer({
    super.key,
    required this.instrumentController,
  });

  @override
  State<CustomInstrumentDrawer> createState() => _CustomInstrumentDrawerState();
}

class _CustomInstrumentDrawerState extends State<CustomInstrumentDrawer> {
  String? colorName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<InstrumentEnum>(
      controller: widget.instrumentController,
      fieldDecoration: const FieldDecoration(
        hintText: 'Eu sei...',
        hintStyle: TextStyle(
          fontSize: 16,
        ),
      ),
      items: widget.instrumentController.items.toList(),
      dropdownDecoration: DropdownDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      dropdownItemDecoration: const DropdownItemDecoration(
        selectedBackgroundColor: Colors.green,
      ),
      chipDecoration: const ChipDecoration(
        labelStyle: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
