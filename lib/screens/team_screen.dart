import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_edit_button.dart';
import 'package:gestao_ejc/components/forms/custom_team_form.dart';
import 'package:gestao_ejc/components/forms/custom_team_member_form.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
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

  List<TeamModel> teams = [];
  final Map<String, List<TeamMemberModel>> teamMembersMap = {};
  final Set<String> loadingTeams = {};

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

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma equipe encontrada'));
        }

        teams = snapshot.data!;

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
      onExpansionChanged: (expanded) {
        if (expanded && !teamMembersMap.containsKey(team.id)) {
          _loadTeamMembers(team: team);
        }
      },
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: team.type.teamIcon,
          ),
          Expanded(child: Text(team.type.formattedName)),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message:
                'Adicionar membro/tios a equipe ${team.type.formattedName}',
            child: IconButton(
                onPressed: () => _showTeamMemberForm(team: team),
                icon: const Icon(Icons.person_add)),
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
        if (loadingTeams.contains(team.id))
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        else if (teamMembersMap.containsKey(team.id))
          ...teamMembersMap[team.id]!.map((teamMember) => ListTile(
                title: Text(teamMember.member.name),
              ))
        else
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                'Nenhum membro encontrado na equipe ${team.type.formattedName}'),
          ),
      ],
    );
  }

  void _loadTeamMembers({required TeamModel team}) async {
    List<TeamMemberModel> members;
    setState(() {
      loadingTeams.add(team.id);
      teamMembersMap.remove(team.id);
    });

    try {
      members = await _teamMemberController.getMemberByTeamAndEncounter(
            sequentialEncounter: widget.encounter.sequential,
            team: team,
          ) ??
          [];

      setState(() {
        if (members.isNotEmpty) {
          teamMembersMap[team.id] = members;
        }
        loadingTeams.remove(team.id);
      });
    } catch (e) {
      setState(() {
        loadingTeams.remove(team.id);
      });
      CustomSnackBar.show(
        context: context,
        message:
            'Erro ao carregar membros da equipe ${team.type.formattedName}: $e',
        colorBar: Colors.red,
      );
    }
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

    _loadTeamMembers(team: team);
  }
}
