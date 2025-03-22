import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/screens/model_screen.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final TextEditingController _memberNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      title: 'Membros',
      body: Column(
        children: [
          CustomSearchRow(
              messageButton: 'Criar Membro',
              functionButton: () => {},
              showButton: true,
              inputType: TextInputType.text,
              controller: _memberNameController,
              messageTextField: 'Pesquisar Membro',
              functionTextField: () {},
              iconButton: const Icon(Icons.add)),
          Expanded(
            child: _buildEncounterList(context),
          )
        ],
      ),
      indexMenuSelected: 1,
      showMenuDrawer: true,
    );
  }

  Widget _buildEncounterList(BuildContext context) {
    return Container();
  }
}
