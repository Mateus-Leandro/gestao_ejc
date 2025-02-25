import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/team_controller.dart';
import 'package:gestao_ejc/enums/team_type_enum.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/team_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class TeamScreen extends StatefulWidget {
  final EncounterModel encounter;
  const TeamScreen({super.key, required this.encounter});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
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

  final TextEditingController teamNameController = TextEditingController();
  final TeamController _teamController = getIt<TeamController>();
  List<TeamModel> teams = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchRow(
            messageButton: 'Criar Equipe',
            functionButton: () => (),
            showButton: true,
            inputType: TextInputType.text,
            controller: teamNameController,
            messageTextField: 'Pesquisar Equipe',
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
        stream: _teamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carrregar Equipes: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma equipe encontrada'));
          }

          teams = snapshot.data!;
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              var team = teams[index];
              return _buildTeamTile(context, team);
            },
          );
        });
  }

  Widget _buildTeamTile(BuildContext context, TeamModel team) {
    return CustomListTile(
      listTile: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: team.type.teamIcon,
            ),
            Text(" -  ${team.type.formattedName}"),
          ],
        ),
      ),
      defaultBackgroundColor: Colors.white,
    );
  }
}
