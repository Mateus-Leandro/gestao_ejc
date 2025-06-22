import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/alerts/custom_vinculation_alert.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/drawers/custom_color_drawer.dart';
import 'package:gestao_ejc/components/drawers/custom_person_drawer.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/circle_controller.dart';
import 'package:gestao_ejc/controllers/circle_member_controller.dart';
import 'package:gestao_ejc/controllers/person_controller.dart';
import 'package:gestao_ejc/controllers/team_controller.dart';
import 'package:gestao_ejc/controllers/team_member_controller.dart';
import 'package:gestao_ejc/enums/circle_color_enum.dart';
import 'package:gestao_ejc/enums/team_type_enum.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/circle_member_model.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/team_member_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:uuid/uuid.dart';

class CustomCircleMemberForm extends StatefulWidget {
  final EncounterModel encounter;
  final CircleColorEnum? linkedCircleColor;
  const CustomCircleMemberForm({
    super.key,
    required this.linkedCircleColor,
    required this.encounter,
  });

  @override
  State<CustomCircleMemberForm> createState() => _CustomCircleMemberFormState();
}

class _CustomCircleMemberFormState extends State<CustomCircleMemberForm> {
  final _formKey = GlobalKey<FormState>();
  AbstractPersonModel? selectedCircleMember;
  final circleMemberSelectionController =
      MultiSelectController<AbstractPersonModel>();
  final MultiSelectController<AbstractPersonModel> _personControllerDrawer =
      MultiSelectController();
  final PersonController _personController = getIt<PersonController>();
  final CircleMemberController _circleMemberController =
      getIt<CircleMemberController>();
  final CircleController _circleController = getIt<CircleController>();
  final TeamMemberController _teamMemberController =
      getIt<TeamMemberController>();
  final TeamController _teamController = getIt<TeamController>();
  bool _loadingMembers = false;
  bool _isLoadingSaveCircleMember = false;
  List<AbstractPersonModel> _listPersons = [];
  CircleColorEnum selectedCircleColor = CircleColorEnum.amarelo;

  @override
  void initState() {
    super.initState();
    if (widget.linkedCircleColor != null) {
      selectedCircleColor = widget.linkedCircleColor!;
    }
    _getAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    return _loadingMembers
        ? const Center(child: CircularProgressIndicator())
        : CustomModelForm(
            title: 'Vincular Membro/Tio no Círculo',
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
                  const Text('Círculo que o membro/tio será vinculado',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  CustomColorDrawer(
                    initialColor: selectedCircleColor,
                    colorSelected: (newCircle) {
                      setState(() {
                        selectedCircleColor = newCircle;
                      });
                    },
                    tooltipMessage: 'Círculo que o membro/tio será vinculado',
                    allowSelection: false,
                    encounterModel: widget.encounter,
                    allCircles: false,
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
      if (_isLoadingSaveCircleMember) ...[
        const Text('Vinculando membro/tio no círculo, aguarde...'),
        const CircularProgressIndicator()
      ] else ...[
        CustomCancelButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        CustomConfirmationButton(
          onPressed: () {
            if (_personControllerDrawer.selectedItems.isNotEmpty) {
              _saveCircleMember();
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

  _saveCircleMember() async {
    setState(() {
      _isLoadingSaveCircleMember = true;
    });
    bool confirmed = true;
    try {
      AbstractPersonModel person =
          _personControllerDrawer.selectedItems.first.value;
      final DocumentReference referenceMember =
          FirebaseFirestore.instance.collection('persons').doc(person.id);

      TeamMemberModel? currentTeamMember =
          await _teamMemberController.getMemberCurrentTeam(
              referenceMember: referenceMember,
              sequentialEncounter: widget.encounter.sequential);

      if (currentTeamMember != null) {
        currentTeamMember.team = await _teamController.teamByReference(
            referenceTeam: currentTeamMember.referenceTeam);

        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'O membro selecionado já está em uma equipe do encontro',
          text:
              'Membro já vinculado na equipe ${currentTeamMember.team.type.formattedName.toLowerCase()}.',
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
        );

        setState(() {
          _isLoadingSaveCircleMember = false;
        });
        return;
      }

      final DocumentReference? referenceCircle =
          await _circleController.referenceCircleByTypeAndEncounter(
              sequentialEncounter: widget.encounter.sequential,
              circleColor: selectedCircleColor);

      CircleMemberModel? currentCircleMember =
          await _circleMemberController.getMemberCurrentCircle(
              referenceMember: referenceMember,
              sequentialEncounter: widget.encounter.sequential);

      CircleMemberModel _savingCircleMemberModel = CircleMemberModel(
          id: currentCircleMember != null
              ? currentCircleMember.id
              : const Uuid().v4(),
          sequentialEncounter: widget.encounter.sequential,
          referenceMember: referenceMember,
          referenceCircle: referenceCircle!);

      if (currentCircleMember != null) {
        currentCircleMember.circle = await _circleController.circleByReference(
            referenceCircle: currentCircleMember.referenceCircle);
        confirmed = await showAlreadyLinkedDialog(
            context: context,
            actualTeam:
                'no círculo ${currentCircleMember.circle.color.circleName}',
            destinationTeam: 'o círculo ${selectedCircleColor.circleName}');
      }

      if (confirmed) {
        await _circleMemberController.saveCircleMember(
            circleMember: _savingCircleMemberModel);
        CustomSnackBar.show(
          context: context,
          message: 'Membro/tio vinculado com sucesso!',
          colorBar: Colors.green,
        );
      }
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: e.toString(),
        colorBar: Colors.red,
      );
    } finally {
      setState(() {
        _isLoadingSaveCircleMember = false;
      });
      Navigator.of(context).pop();
    }
  }
}
