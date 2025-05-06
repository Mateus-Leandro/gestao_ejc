import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/drawers/custom_person_drawer.dart';
import 'package:gestao_ejc/components/drawers/custom_team_type_drawer.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/person_controller.dart';
import 'package:gestao_ejc/controllers/team_controller.dart';
import 'package:gestao_ejc/controllers/team_member_controller.dart';
import 'package:gestao_ejc/enums/team_type_enum.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/team_member_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:uuid/uuid.dart';

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
  final teamMemberSelectionController =
      MultiSelectController<AbstractPersonModel>();
  final MultiSelectController<AbstractPersonModel> _personControllerDrawer =
      MultiSelectController();
  final PersonController _personController = getIt<PersonController>();
  final TeamController _teamController = getIt<TeamController>();
  final TeamMemberController _teamMemberController =
      getIt<TeamMemberController>();
  bool _loadingMembers = false;
  bool _isLoadingSaveTeamMember = false;
  List<AbstractPersonModel> _listPersons = [];
  TeamTypeEnum selectedTeam = TeamTypeEnum.apoioEAcolhida;

  @override
  void initState() {
    super.initState();
    _getAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    return _loadingMembers
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
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPersonDrawer(personControllerDrawer: _personControllerDrawer),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Selecione a equipe que o membroi/tio será vinculado',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  CustomTeamTypeDrawer(
                    initialTeamType: selectedTeam,
                    teamTypeSelected: (team) {
                      setState(
                        () {
                          selectedTeam = team;
                        },
                      );
                    },
                    tooltipMessage:
                        'Escolha a equipe que deseja vincular o membro',
                    allowSelection: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> _buildFormAction() {
    return [
      if (_isLoadingSaveTeamMember) ...[
        const Text('Vinculando membro/tio na equipe, aguarde...'),
        const CircularProgressIndicator()
      ] else ...[
        CustomCancelButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        CustomConfirmationButton(
          onPressed: () {
            if (selectedTeam != null &&
                _personControllerDrawer.selectedItems.isNotEmpty) {
              _saveTeamMember();
            }
          },
        ),
      ]
    ];
  }

  _getAllMembers() async {
    setState(() {
      _loadingMembers = true;
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
      _loadingMembers = false;
    });
  }

  _saveTeamMember() async {
    setState(() {
      _isLoadingSaveTeamMember = true;
    });
    try {
      AbstractPersonModel person =
          _personControllerDrawer.selectedItems.first.value;
      final DocumentReference referenceMember =
          FirebaseFirestore.instance.collection('persons').doc(person.id);
      final DocumentReference? referenceTeam =
          await _teamController.referenceTeamByTypeAndEncounter(
              sequentialEncounter: widget.encounter.sequential,
              type: selectedTeam!);
      TeamMemberModel _teamMemberModel = TeamMemberModel(
          id: const Uuid().v4(),
          sequentialEncounter: widget.encounter.sequential,
          referenceMember: referenceMember,
          referenceTeam: referenceTeam!);
      _teamMemberController.saveTeamMember(teamMemberModel: _teamMemberModel);
      CustomSnackBar.show(
        context: context,
        message: 'Membro/tio vinculado com sucesso!',
        colorBar: Colors.green,
      );
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: e.toString(),
        colorBar: Colors.red,
      );
    } finally {
      setState(() {
        _isLoadingSaveTeamMember = false;
      });
      Navigator.of(context).pop();
    }
  }
}
