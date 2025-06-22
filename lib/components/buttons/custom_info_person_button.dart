import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/forms/custom_person_form.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';

class CustomInfoPersonButton extends StatelessWidget {
  final AbstractPersonModel person;
  const CustomInfoPersonButton({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Visualizar Informações',
      child: IconButton(
          onPressed: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return CustomPersonForm(
                  editingPerson: person,
                  readOnly: true,
                );
              },
            );
          },
          icon: const Icon(Icons.person)),
    );
  }
}
