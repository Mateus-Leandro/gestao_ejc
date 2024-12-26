import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class AuthController {
  final AuthService _authService = getIt<AuthService>();

  Future<void> logIn({required String email, required String senha}) async {
    try {
      await _authService.logIn(email: email, senha: senha);
    } catch (e) {
      throw 'Erro ao fazer login: $e';
    }
  }

  Future<void> logOut() async {
    try {
      await _authService.logOut();
    } catch (e) {
      throw 'Erro ao fazer logout: $e';
    }
  }

  Future<void> createUser(
      {required UserModel user, required String password}) async {
    try {
      await _authService.createUser(user: user, password: password);
    } catch (e) {
      throw 'Erro ao criar usuário: $e';
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _authService.resetPassword(email: email);
    } catch (e) {
      throw 'Erro ao redefinir senha: $e';
    }
  }

  bool userHasPermission(
      {required BuildContext context, required UserModel user}) {
    return _authService.userHasPermission(context: context, user: user);
  }
}
