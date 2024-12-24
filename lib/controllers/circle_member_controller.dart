import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/circle_member_model.dart';
import 'package:gestao_ejc/services/circle_member_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleMemberController extends ChangeNotifier {
  var _streamcontroller;
  final CircleMemberService _circleMemberService = getIt<CircleMemberService>();
  Stream<List<CircleMemberModel>>? get stream => _streamcontroller.stream;
  List<CircleMemberModel?>? circleMembers;

  void init() {
    _streamcontroller = StreamController<List<CircleMemberModel>>();
    getCircleMembers();
  }

  @override
  void dispose() {
    _streamcontroller.close();
    super.dispose();
  }

  void getCircleMembers() async {
    circleMembers = await _circleMemberService.getCircleMembers();
    _streamcontroller.sink.add(circleMembers);
  }

  Future<bool> saveCircleMember(
      {required CircleMemberModel circleMember}) async {
    if (await _circleMemberService.saveCircleMember(
        circleMember: circleMember)) {
      getCircleMembers();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteCircleMember(
      {required CircleMemberModel circleMember}) async {
    if (await _circleMemberService.deleteCircleMember(
        circleMember: circleMember)) {
      getCircleMembers();
      return true;
    } else {
      return false;
    }
  }
}
