import 'package:flutter/material.dart';
import 'package:gestao_ejc/enums/instrument_enum.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CustomInstrumentDrawer extends StatefulWidget {
  final MultiSelectController<InstrumentEnum> instrumentController;
  final bool? readOnly;
  const CustomInstrumentDrawer({
    super.key,
    required this.instrumentController,
    this.readOnly,
  });

  @override
  State<CustomInstrumentDrawer> createState() => _CustomInstrumentDrawerState();
}

class _CustomInstrumentDrawerState extends State<CustomInstrumentDrawer> {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.readOnly == true,
      child: MultiDropdown<InstrumentEnum>(
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
      ),
    );
  }
}
