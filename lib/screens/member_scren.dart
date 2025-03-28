import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/forms/custom_person_form.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/screens/model_screen.dart';

class MemberScren extends StatefulWidget {
  const MemberScren({super.key});

  @override
  State<MemberScren> createState() => _MemberScrenState();
}

class _MemberScrenState extends State<MemberScren> {
  final TextEditingController _memberNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      title: 'Membros',
      body: Column(
        children: [
          CustomSearchRow(
            messageButton: 'Incluir Membro',
            functionButton: () => _showPersonForm(null),
            showButton: true,
            inputType: TextInputType.text,
            controller: _memberNameController,
            messageTextField: 'Pesquisar membro/tio',
            functionTextField: () => (),
            iconButton: const Icon(Icons.add),
          )
        ],
      ),
      indexMenuSelected: 1,
      showMenuDrawer: true,
    );
  }

  void _showPersonForm(AbstractPersonModel? person) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomPersonForm(
          editingPerson: person,
        );
      },
    );
  }
}
