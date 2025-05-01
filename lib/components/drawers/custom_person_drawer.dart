import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CustomPersonDrawer extends StatefulWidget {
  final MultiSelectController<AbstractPersonModel> personControllerDrawer;
  const CustomPersonDrawer({
    super.key,
    required this.personControllerDrawer,
  });

  @override
  State<CustomPersonDrawer> createState() => _CustomPersonDrawerState();
}

class _CustomPersonDrawerState extends State<CustomPersonDrawer> {
  String? colorName;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<AbstractPersonModel>(
      searchDecoration: const SearchFieldDecoration(
          hintText: 'Clique aqui e pesquise o membro/tio'),
      controller: widget.personControllerDrawer,
      searchEnabled: true,
      singleSelect: true,
      fieldDecoration: const FieldDecoration(
        hintText: 'Eu sei...',
        hintStyle: TextStyle(
          fontSize: 16,
        ),
      ),
      items: widget.personControllerDrawer.items.toList(),
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
