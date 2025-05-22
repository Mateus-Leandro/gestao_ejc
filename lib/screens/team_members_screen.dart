import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/forms/custom_team_member_form.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/team_member_controller.dart';
import 'package:gestao_ejc/enums/team_type_enum.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/team_member_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class TeamMembersScreen extends StatefulWidget {
  final EncounterModel encounter;
  const TeamMembersScreen({super.key, required this.encounter});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  @override
  void initState() {
    _TeamMemberController.init(
        sequentialEncounter: widget.encounter.sequential);
    super.initState();
  }

  @override
  void dispose() {
    _TeamMemberController.dispose();
    super.dispose();
  }

  final TextEditingController teamNameController = TextEditingController();
  final TeamMemberController _TeamMemberController =
      getIt<TeamMemberController>();
  List<TeamMemberModel> teamMembers = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchRow(
            messageButton: 'Adicionar Membro/tio',
            functionButton: () => _showTeamMemberForm(),
            showButton: true,
            inputType: TextInputType.text,
            controller: teamNameController,
            messageTextField: 'Pesquisar Membro/tio',
            functionTextField: () => (),
            iconButton: const Icon(Icons.add),
          ),
          Expanded(child: _buildTeamList(context))
        ],
      ),
    );
  }

  Widget _buildTeamList(BuildContext context) {
    return StreamBuilder(
        stream: _TeamMemberController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carrregar Membros/Tios: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum membro/tio encontrado'));
          }

          teamMembers = snapshot.data!;
          return ListView.builder(
            itemCount: teamMembers.length,
            itemBuilder: (context, index) {
              var teamMember = teamMembers[index];
              return _buildTeamTile(context, teamMember);
            },
          );
        });
  }

  Widget _buildTeamTile(BuildContext context, TeamMemberModel teamMember) {
    return CustomListTile(
      listTile: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: teamMember.team.type.teamIcon,
            ),
            Text(teamMember.member.name),
          ],
        ),
        // trailing: CustomEditButton(
        //   form: CustomTeamForm(
        //     teamEditing: teamMember,
        //     encounter: widget.encounter,
        //   ),
        // ),
      ),
      defaultBackgroundColor: Colors.white,
    );
  }

  void _showTeamMemberForm({AbstractPersonModel? teamMember}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomTeamMemberForm(
          linkedTeam: null,
          encounter: widget.encounter,
          teamMembers: _TeamMemberController.actualMemberList,
        );
      },
    );
  }
}
