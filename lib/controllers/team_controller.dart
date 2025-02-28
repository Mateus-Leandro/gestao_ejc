import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gestao_ejc/enums/team_type_enum.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/models/team_model.dart';
import 'package:gestao_ejc/services/firebase_storage_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/team_service.dart';

class TeamController extends ChangeNotifier {
  final TeamService _teamService = getIt<TeamService>();
  final FirebaseStorageService firebaseStorageService =
      getIt<FirebaseStorageService>();
  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
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

  Future<Uint8List?> getTeamImage({required TeamModel team}) async {
    try {
      return await firebaseStorageService.getImage(
          imagePath:
              'encounters/${functionIntToRoman.convert(team.sequentialEncounter)}/teams/${team.type.formattedName}/teamImage.png');
    } catch (e) {
      throw 'Erro ao retornar imagem da equipe: $e';
    }
  }

  Future<String> saveTeamImage(
      {required Uint8List image, required TeamModel team}) async {
    try {
      String? url = await firebaseStorageService.uploadImage(
          image: image,
          path:
              'encounters/${functionIntToRoman.convert(team.sequentialEncounter)}/teams/${team.type.formattedName}/teamImage.png');
      return url ?? '';
    } catch (e) {
      throw 'Erro ao salvar imagem da equipe: $e';
    }
  }

  Future<void> removeTeamImage({
    required TeamModel team,
  }) async {
    try {
      await firebaseStorageService.deleteImage(
          imagePath:
              'encounters/${functionIntToRoman.convert(team.sequentialEncounter)}/teams/${team.type.formattedName}/teamImage.png');
    } catch (e) {
      throw 'Erro ao remover imagem da equipe: $e';
    }
  }

  Future<void> updateImage({required TeamModel team}) async {
    try {
      await _teamService.updateUrlImage(team: team);
      getTeams(sequentialEncounter: team.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao atualizar imagens do círculo: $e';
    }
  }
}
