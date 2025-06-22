import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/buttons/custom_delete_button.dart';
import 'package:gestao_ejc/components/buttons/custom_edit_button.dart';
import 'package:gestao_ejc/components/buttons/custom_info_person_button.dart';
import 'package:gestao_ejc/components/forms/custom_team_form.dart';
import 'package:gestao_ejc/components/forms/custom_team_member_form.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/components/utils/utils.dart';
import 'package:gestao_ejc/controllers/team_controller.dart';
import 'package:gestao_ejc/controllers/team_member_controller.dart';
import 'package:gestao_ejc/enums/team_type_enum.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/team_member_model.dart';
import 'package:gestao_ejc/models/team_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class TeamScreen extends StatefulWidget {
  final EncounterModel encounter;
  const TeamScreen({super.key, required this.encounter});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final TextEditingController teamNameController = TextEditingController();
  final TeamController _teamController = getIt<TeamController>();
  final TeamMemberController _teamMemberController =
      getIt<TeamMemberController>();

  @override
  void initState() {
    _teamController.init(sequentialEncounter: widget.encounter.sequential);
    super.initState();
  }

  @override
  void dispose() {
    _teamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomSearchRow(
            messageButton: 'Criar Equipe',
            functionButton: () => _showTeamForm(null),
            showButton: true,
            inputType: TextInputType.text,
            controller: teamNameController,
            messageTextField: 'Pesquisar Equipe',
            functionTextField: () => (),
            iconButton: const Icon(Icons.add),
          ),
          Expanded(child: _buildTeamList(context)),
        ],
      ),
    );
  }

  Widget _buildTeamList(BuildContext context) {
    return StreamBuilder<List<TeamModel>>(
      stream: _teamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar Equipes: ${snapshot.error}'));
        }

        final teams = snapshot.data ?? [];
        if (teams.isEmpty) {
          return const Center(child: Text('Nenhuma equipe encontrada'));
        }

        return ExpansionTileList(
          children: teams
              .map((team) => _buildExpansionTileItem(context, team))
              .toList(),
        );
      },
    );
  }

  ExpansionTileItem _buildExpansionTileItem(
      BuildContext context, TeamModel team) {
    return ExpansionTileItem(
      enableTrailingAnimation: false,
      iconColor: Colors.indigo,
      initiallyExpanded: false,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: team.type.teamIcon,
          ),
          Expanded(child: Text(team.type.formattedName)),
        ],
      ),
      trailing: Utils.isSmallScreen(context)
          ? PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'incluir') {
                  _showTeamMemberForm(team: team);
                } else if (value == 'editar') {
                  _showTeamForm(team);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'incluir',
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Incluir membro'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'editar',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message:
                      'Adicionar membro/tios à equipe ${team.type.formattedName}',
                  child: IconButton(
                    onPressed: () => _showTeamMemberForm(team: team),
                    icon: const Icon(Icons.add),
                  ),
                ),
                CustomEditButton(
                  form: CustomTeamForm(
                    teamEditing: team,
                    encounter: widget.encounter,
                  ),
                ),
              ],
            ),
      children: [
        FutureBuilder<List<TeamMemberModel>>(
          future: _teamMemberController.getMemberByTeamAndEncounter(
            sequentialEncounter: widget.encounter.sequential,
            team: team,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Erro ao carregar membros: ${snapshot.error}'),
              );
            }

            final members = snapshot.data ?? [];

            if (members.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text('Nenhum membro na equipe ${team.type.formattedName}'),
              );
            }

            return Column(
              children: members
                  .map((teamMember) => ListTile(
                        title: Row(
                          children: [
                            CustomInfoPersonButton(person: teamMember.member),
                            Expanded(child: Text(teamMember.member.name)),
                            CustomDeleteButton(
                              alertMessage:
                                  'Remover ${teamMember.member.name} da equipe ${team.type.formattedName}?',
                              deleteFunction: () => _removeTeamMember(
                                  teamMember: teamMember, team: team),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  void _showTeamForm(TeamModel? team) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomTeamForm(
          encounter: widget.encounter,
          teamEditing: team,
        );
      },
    );
  }

  void _showTeamMemberForm({required TeamModel team}) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomTeamMemberForm(
          encounter: widget.encounter,
          teamMembers: _teamMemberController.actualMemberList,
          linkedTeam: team.type,
        );
      },
    );
    setState(() {});
  }

  Future _removeTeamMember(
      {required TeamMemberModel teamMember, required TeamModel team}) async {
    await _teamMemberController.deleteTeamMember(teamMemberModel: teamMember);
    setState(() {});
  }
}
