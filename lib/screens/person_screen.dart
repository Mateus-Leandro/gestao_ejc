import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/forms/custom_person_form.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/person_controller.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final TextEditingController _memberNameController = TextEditingController();
  final PersonController _personController = getIt<PersonController>();
  bool loadingMembers = false;

  @override
  void initState() {
    super.initState();
    _personController.init();
  }

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
          ),
          Expanded(child: _buildMembersList(context)),
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

  Widget _buildMembersList(BuildContext context) {
    return StreamBuilder(
        stream: _personController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar membros/tios: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum membro/tio encontrado'));
          }

          var persons = snapshot.data!;

          return ListView.builder(
            itemCount: persons.length,
            itemBuilder: (context, index) {
              var person = persons[index];
              return _buildMemberTile(
                context,
                person,
              );
            },
          );
        });
  }

  _buildMemberTile(BuildContext context, AbstractPersonModel person) {
    return CustomListTile(
        listTile: ListTile(
          title: Text(person.name),
        ),
        defaultBackgroundColor: Colors.white);
  }
}
