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

  Future<String?> saveUser(
      {required UserModel newUser, String? password}) async {
    String? result;

    if (password == null) {
      result = await _userService.saveUser(newUser);
    } else {
      result = await _authService.createUser(user: newUser, password: password);
    }

    if (result == null) {
      getUsers(null);
      return null;
    } else {
      return result;
    }
  }

  Future<String?> changeUserState({required UserModel user}) async {
    user.active = !user.active;
    return await saveUser(newUser: user, password: null);
  }
}
