import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/member_model.dart';
import 'package:gestao_ejc/models/team_member_model.dart';
import 'package:gestao_ejc/models/team_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/team_member_service.dart';

class TeamMemberController extends ChangeNotifier {
  final TeamMemberService _teamMemberService = getIt<TeamMemberService>();
  List<TeamMemberModel> listTeamMember = [];
  List<TeamMemberModel> filterListTeamMember = [];

  var _streamController;
  Stream<List<TeamMemberModel>>? get stream => _streamController.stream;

  void init({required int sequentialEncounter}) {
    _streamController = StreamController<List<TeamMemberModel>>();
    getTeamMembers(sequentialEncounter: sequentialEncounter);
  }

  @override
  void dispose() {
    if (!_streamController.isClosed) {
      _streamController.close();
    }
    super.dispose();
  }

  Future<void> getTeamMembers({required int sequentialEncounter}) async {
    try {
      listTeamMember = await _teamMemberService.getTeamMembers(
          sequentialEncounter: sequentialEncounter);
      await Future.wait(listTeamMember.map((teamMember) async {
        final memberByReference = await teamMember.referenceMember.get();
        if (memberByReference.exists && memberByReference.data() != null) {
          teamMember.member = MemberModel.fromJson(
              memberByReference.data() as Map<String, dynamic>);
        }
        final teamByReference = await teamMember.referenceTeam.get();
        if (teamByReference.exists && teamByReference.data() != null) {
          teamMember.team = TeamModel.fromJson(
              teamByReference.data() as Map<String, dynamic>);
        }
      }));

      filterListTeamMember = listTeamMember;
      _streamController.sink.add(listTeamMember);
    } catch (e) {
      throw 'Erro ao buscar membros/tios';
    }
  }

  void filterTeamMember({required String? teamMemberName}) {
    try {
      teamMemberName != null
          ? filterListTeamMember = listTeamMember
              .where((teamMember) => teamMember.member.name
                  .toLowerCase()
                  .contains(teamMemberName.toLowerCase()))
              .toList()
          : filterListTeamMember = listTeamMember;
    } catch (e) {
      throw 'Erro ao buscar membro/tio';
    }
  }

  Future<void> saveTeamMember(
      {required TeamMemberModel teamMemberModel}) async {
    try {
      await _teamMemberService.saveTeamMember(teamMember: teamMemberModel);
      await getTeamMembers(
          sequentialEncounter: teamMemberModel.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao salvar membro/tio';
    }
  }

  Future<void> deleteTeamMember(
      {required TeamMemberModel teamMemberModel}) async {
    try {
      await _teamMemberService.deleteTeamMeber(
          teamMemberId: teamMemberModel.id);
    } catch (e) {
      throw 'Erro ao deletar membro';
    }
  }

  get actualMemberList => listTeamMember;
}
