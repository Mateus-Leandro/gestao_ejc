import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:gestao_ejc/models/userModel.dart';
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
    getUsers();
  }

  void getUsers() async {
    var response = await _userService.getUsers();
    _streamController.sink.add(response);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<String?> addUser({required UserModel newUser, required String password}) async {
    String? result =
        await _authService.createUser(user: newUser, password: password);
    if (result == null) {
      getUsers();
      return null;
    } else {
      return result;
    }
  }
}
