import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/drawers/custom_person_drawer.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/person_controller.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/team_member_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CustomTeamMemberForm extends StatefulWidget {
  final TeamMemberModel? teamMemberEditing;
  final EncounterModel encounter;
  final List<TeamMemberModel> teamMembers;
  const CustomTeamMemberForm({
    super.key,
    this.teamMemberEditing,
    required this.encounter,
    required this.teamMembers,
  });

  @override
  State<CustomTeamMemberForm> createState() => _CustomTeamMemberFormState();
}

class _CustomTeamMemberFormState extends State<CustomTeamMemberForm> {
  final _formKey = GlobalKey<FormState>();
  AbstractPersonModel? selectedTeamMember;
  final teamMemberController = MultiSelectController<AbstractPersonModel>();
  final MultiSelectController<AbstractPersonModel> _personControllerDrawer =
      MultiSelectController();
  final PersonController _personController = getIt<PersonController>();
  bool loadingMembers = false;
  List<AbstractPersonModel> _listPersons = [];

  @override
  void initState() {
    super.initState();
    _getAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    return loadingMembers
        ? const Center(child: CircularProgressIndicator())
        : CustomModelForm(
            title: widget.teamMemberEditing != null
                ? 'Editar Membro/Tio'
                : 'Vincular Membro/Tio na Equipe',
            formKey: _formKey,
            formBody: _buildFormBody(),
            actions: _buildFormAction(),
          );
  }

  _buildFormBody() {
    return [
      Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPersonDrawer(personControllerDrawer: _personControllerDrawer)
          ],
        ),
      )
    ];
  }

  _buildFormAction() {
    return [
      Container(),
    ];
  }

  _getAllMembers() async {
    setState(() {
      loadingMembers = true;
    });

    await _personController.getPersons();
    _listPersons = _personController.getActualListPersons;
    _personControllerDrawer.setItems(_listPersons.map((person) {
      return DropdownItem(
        label: person.name,
        value: person,
        selected: false,
      );
    }).toList());
    setState(() {
      loadingMembers = false;
    });
  }
}
