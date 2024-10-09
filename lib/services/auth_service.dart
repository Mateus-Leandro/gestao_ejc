import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/user_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final UserService _userService = getIt<UserService>();
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  UserModel? actualUserModel;

  Future<String?> logIn({required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await saveActualUserModel(idUser: user.uid);
      }
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }

  Future<String?> createUser(
      {required UserModel user, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: password);
      User? newUser = userCredential.user;
      await newUser?.updateDisplayName(user.name);
      await newUser?.reload();
      if (newUser != null) {
        user.id = newUser.uid;
        _userService.saveUser(user);
      }
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }

  Future<String?> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<String?> erroAuth(FirebaseAuthException e) async {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'invalid-email':
        return 'Email Inválido/não encontrado.';
      case 'email-already-in-use':
        return 'O email já está em uso.';
      case 'invalid-credential':
        return 'Credenciais inválidas.';
      case 'weak-password':
        return 'Senha fraca';
      default:
        return 'Erro, tente novamente.';
    }
  }

  Future<UserModel?> get getActualUserModel async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    if (actualUserModel == null) {
      String? errorMessage = await saveActualUserModel(idUser: user.uid);
      if (errorMessage != null) {
        print(errorMessage);
        return null;
      }
    }
    return actualUserModel;
  }

  Future<String?> saveActualUserModel({required String idUser}) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(idUser).get();
      if (snapshot.exists && snapshot.data() != null) {
        actualUserModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return null;
      } else {
        return "Documento não encontrado ou sem dados.";
      }
    } catch (e) {
      return "Erro ao buscar usuário: $e";
    }
  }

  String? userHasPermission(
      {required BuildContext context, required UserModel user}) {
    String? actualRoute = ModalRoute.of(context)?.settings.name;
    if (!user.active) {
      return 'Usuário inativo!';
    }
    switch (actualRoute) {
      case '/users':
        if (user.manipulateUsers == true) {
          return null;
        } else {
          return 'Sem permissão de acesso aos usuários.';
        }
      default:
        return null;
    }
  }
}
