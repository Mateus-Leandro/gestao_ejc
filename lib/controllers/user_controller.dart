import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/user_service.dart';

class UserController extends ChangeNotifier {
  final UserService _userService = getIt<UserService>();
  final AuthService _authService = getIt<AuthService>();

  var _streamController;

  Stream<List<UserModel>>? get stream => _streamController.stream;

  void init() {
    _streamController = StreamController<List<UserModel>>();
    getUsers(null);
  }

  void getUsers(String? userName) async {
    var response = await _userService.getUsers(userName?.toLowerCase());
    _streamController.sink.add(response);
  }

  Future<String?> getNameByReferenceUser(
      {required DocumentReference referenceUser}) async {
    return await _userService.getNameByReferenceUser(
        referenceUser: referenceUser);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> saveUser({required UserModel newUser, String? password}) async {
    try {
      if (password == null) {
        await _userService.saveUser(newUser);
      } else {
        await _authService.createUser(user: newUser, password: password);
      }
      getUsers(null);
    } catch (e) {
      throw 'Erro ao ${password == null ? 'salvar' : 'criar'} usuário: $e';
    }
  }

  Future<void> changeUserState({required UserModel user}) async {
    user.active = !user.active;
    try {
      await saveUser(newUser: user, password: null);
    } catch (e) {
      throw 'Erro ao alterar status do usuário: $e';
    }
  }
}
