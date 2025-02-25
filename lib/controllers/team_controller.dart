import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gestao_ejc/models/team_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/team_service.dart';

class TeamController extends ChangeNotifier {
  final TeamService _teamService = getIt<TeamService>();
  var _streamController;
  Stream<List<TeamModel>>? get stream => _streamController.stream;
  List<TeamModel> teams = [];

  void init({required int sequentialEncounter}) {
    _streamController = StreamController<List<TeamModel>>();
    getTeams(sequentialEncounter: sequentialEncounter);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void getTeams({required int sequentialEncounter}) async {
    try {
      teams = await _teamService.getTeams(
        sequentialEncounter: sequentialEncounter,
      );
      _streamController.sink.add(teams);
    } catch (e) {
      throw 'Erro ao listar equipes: $e';
    }
  }

  Future<void> saveTeam({required TeamModel team}) async {
    try {
      await _teamService.saveTeam(team: team);
    } catch (e) {
      throw 'Erro ao salvar equipe: $e';
    }
  }

  Future<void> deleteTeam({required TeamModel team}) async {
    try {
      await _teamService.deleteTeam(team: team);
    } catch (e) {
      'Erro ao deletar equipe: $e';
    }
  }
}
