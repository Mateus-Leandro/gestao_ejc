import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/buttons/custom_pick_file_button.dart';
import 'package:gestao_ejc/components/drawers/custom_team_type_drawer.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/team_controller.dart';
import 'package:gestao_ejc/enums/team_type_enum.dart';
import 'package:gestao_ejc/functions/function_pick_image.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/team_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:uuid/uuid.dart';

class CustomTeamForm extends StatefulWidget {
  final EncounterModel encounter;
  final TeamModel? teamEditing;
  const CustomTeamForm({super.key, this.teamEditing, required this.encounter});

  @override
  State<CustomTeamForm> createState() => _CustomTeamFormState();
}

class _CustomTeamFormState extends State<CustomTeamForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _musicTextController = TextEditingController();
  final FunctionPickImage functionPickImage = getIt<FunctionPickImage>();
  final TeamController _teamController = getIt<TeamController>();
  TeamTypeEnum? selectedTeam;
  bool _isLoadingTeamImage = false;
  bool _isLoadingSaveTeam = false;
  Uint8List? teamImage;
  Uint8List? originalTeamImage;

  @override
  void initState() {
    super.initState();
    if (widget.teamEditing != null) {
      selectedTeam = widget.teamEditing!.type;
      _musicTextController.text = widget.teamEditing!.parodyMusic ?? '';
    }
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: widget.teamEditing == null ? 'Criar Equipe' : 'Editar Equipe',
      formKey: _formKey,
      formBody: _buildFormBody(),
      actions: _buildFormAction(),
    );
  }

  List<Widget> _buildFormBody() {
    return [
      CustomTeamTypeDrawer(
        initialTeamType: widget.teamEditing?.type,
        teamTypeSelected: (newTeam) {
          setState(
            () {
              selectedTeam = newTeam;
            },
          );
        },
        tooltipMessage: widget.teamEditing == null ? 'Escolha a equipe' : '',
        allowSelection: widget.teamEditing == null,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Imagem Equipe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            CustomPickFileButton(
              onPressed: () {
                _pickteamImage();
              },
              icon: Tooltip(
                message: 'Selecionar Imagem da Equipe',
                child: Opacity(
                  opacity: 1.0,
                  child: Stack(
                    alignment: Alignment.topRight,
                    fit: StackFit.loose,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _isLoadingTeamImage
                            ? const Center(child: CircularProgressIndicator())
                            : teamImage != null
                                ? Image.memory(
                                    teamImage!,
                                    height: 250,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  )
                                : const Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child:
                                          Text('Selecionar imagem da Equipe'),
                                    ),
                                  ),
                      ),
                      if (teamImage != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: IconButton(
                            iconSize: 35,
                            icon: const Icon(Icons.close,
                                color: Colors.red, size: 30),
                            onPressed: () {
                              setState(() {
                                teamImage = null;
                              });
                            },
                            tooltip: 'Remover Imagem da Equipe',
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextFormField(
                controller: _musicTextController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(labelText: 'Música Paródia'),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildFormAction() {
    return [
      if (_isLoadingSaveTeam) ...[
        const Text('Salvando equipe, aguarde...'),
        const CircularProgressIndicator()
      ] else ...[
        CustomCancelButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        CustomConfirmationButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _isLoadingSaveTeam = true;
              });
              _saveTeam();
            }
          },
        ),
      ]
    ];
  }

  void _saveTeam() async {
    try {
      final String teamId = widget.teamEditing?.id ?? const Uuid().v4();
      String? urlTeamImage;
      TeamModel team = TeamModel(
        sequentialEncounter: widget.encounter.sequential,
        id: teamId,
        urlImage: '',
        type: selectedTeam!,
        parodyMusic: _musicTextController.text.trim(),
      );

      await _teamController.saveTeam(team: team);

      if (teamImage != originalTeamImage) {
        if (teamImage != null) {
          urlTeamImage = await _teamController.saveTeamImage(
            image: teamImage!,
            team: team,
          );
        } else {
          await _teamController.removeTeamImage(team: team);
          urlTeamImage = '';
        }
      }

      team.urlImage = urlTeamImage;
      await _teamController.updateImage(team: team);

      CustomSnackBar.show(
        context: context,
        message: 'Equipe salva com sucesso!',
        colorBar: Colors.green,
      );
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao salvar equipe: $e',
        colorBar: Colors.red,
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickteamImage() async {
    setState(() {
      _isLoadingTeamImage = true;
    });
    teamImage = await functionPickImage.getSingleImage();
    teamImage ??= originalTeamImage;
    setState(() {
      _isLoadingTeamImage = false;
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      _isLoadingTeamImage = true;
    });

    originalTeamImage = null;
    if (widget.teamEditing!.urlImage!.isNotEmpty) {
      originalTeamImage =
          await _teamController.getTeamImage(team: widget.teamEditing!);
    }

    teamImage = originalTeamImage;
    setState(() {
      _isLoadingTeamImage = false;
    });
  }
}
