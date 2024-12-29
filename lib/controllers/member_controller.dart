import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gestao_ejc/models/member_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/member_service.dart';

class MemberController extends ChangeNotifier {
  final MemberService _memberService = getIt<MemberService>();
  var _streamController;
  Stream<List<MemberModel>>? get stream => _streamController.stream;

  void init() {
    _streamController = StreamController<List<MemberModel>>();
    getMembers();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<List<MemberModel>> getMembers() async {
    try {
      return await _memberService.getMembers();
    } catch (e) {
      throw 'Erro ao listar membros: $e';
    }
  }

  Future<void> saveMember({required MemberModel member}) async {
    try {
      await _memberService.saveMember(member: member);
    } catch (e) {
      throw 'Erro ao salvar membro: $e';
    }
  }

  Future<void> deleteMember({required MemberModel member}) async {
    try {
      await _memberService.deleteMember(member: member);
    } catch (e) {
      'Erro ao deletar membro: $e';
    }
  }
}
