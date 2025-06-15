import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/enums/circle_color_enum.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/circle_member_model.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/services/circle_member_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleMemberController extends ChangeNotifier {
  final CircleMemberService _teamMemberService = getIt<CircleMemberService>();
  var _streamController = StreamController<List<CircleMemberModel>>();
  final CircleMemberService _circleMemberService = getIt<CircleMemberService>();
  Stream<List<CircleMemberModel>>? get stream => _streamController.stream;
  List<CircleMemberModel> listCircleMember = [];
  List<CircleMemberModel> filterListCircleMember = [];

  void init({required int sequentialEncounter}) {
    getCircleMembers(sequentialEncounter: sequentialEncounter);
  }

  @override
  void dispose() {
    if (!_streamController.isClosed) {
      _streamController.close();
    }
    super.dispose();
  }

  Future<void> getCircleMembers({required int sequentialEncounter}) async {
    try {
      listCircleMember = await _circleMemberService.getCircleMembers(
          sequentialEncounter: sequentialEncounter);
      await fillMemberList();
    } catch (e) {
      throw 'Erro ao buscar membros do círculo: $e';
    }
  }

  Future<void> saveCircleMember(
      {required CircleMemberModel circleMember}) async {
    try {
      await _circleMemberService.saveCircleMember(circleMember: circleMember);
      getCircleMembers(sequentialEncounter: circleMember.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao salvar membro do círculo: $e';
    }
  }

  Future<void> deleteCircleMember(
      {required CircleMemberModel circleMember}) async {
    try {
      await _circleMemberService.deleteCircleMember(circleMember: circleMember);
      getCircleMembers(sequentialEncounter: circleMember.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao remover membro do círculo: $e';
    }
  }

  Future<List<CircleMemberModel>>? getMemberByCircleAndEncounter(
      {required int sequentialEncounter, required CircleModel circle}) async {
    try {
      final members = await _circleMemberService.getMemberByTeamAndEncounter(
              sequentialEncounter: sequentialEncounter, circle: circle) ??
          [];
      await fillMemberList(members);
      return members;
    } catch (e) {
      throw 'Erro ao obter membros do círculo ${circle.color.circleName} $e';
    }
  }

  Future<void> fillMemberList([List<CircleMemberModel>? members]) async {
    final list = members ?? listCircleMember;
    await Future.wait(list.map((teamMember) async {
      final memberByReference = await teamMember.referenceMember.get();
      if (memberByReference.exists && memberByReference.data() != null) {
        teamMember.member = AbstractPersonModel.fromJson(
            memberByReference.data() as Map<String, dynamic>);
      }
      final circleByReference = await teamMember.referenceCircle.get();
      if (circleByReference.exists && circleByReference.data() != null) {
        teamMember.circle = CircleModel.fromJson(
            circleByReference.data() as Map<String, dynamic>);
      }
    }));
    if (members == null) {
      filterListCircleMember = listCircleMember;
      _streamController.sink.add(listCircleMember);
    }
  }

  Future<CircleMemberModel?> getMemberCurrentCircle({
    required int sequentialEncounter,
    required DocumentReference referenceMember,
  }) async {
    try {
      return await _circleMemberService.getMemberCurrentCircle(
        referenceMember: referenceMember,
        sequentialEncounter: sequentialEncounter,
      );
    } catch (e) {
      rethrow;
    }
  }

  get actualMemberList => listCircleMember;
}
