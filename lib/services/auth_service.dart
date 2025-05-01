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

  Future logIn({required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await saveActualUserModel(idUser: user.uid);
      }
    } on FirebaseAuthException catch (e) {
      throw erroAuth(e);
    }
  }

  Future<void> createUser(
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
      throw erroAuth(e);
    }
  }

  Future resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw erroAuth(e);
    }
    return null;
  }

  Future logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw erroAuth(e);
    }
  }

  String erroAuth(FirebaseAuthException e) {
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
        return 'Credenciais inválidas';
      case 'weak-password':
        return 'Senha fraca';
      default:
        return 'Erro, tente novamente.';
    }
  }

  Future<UserModel?> get getActualUserModel async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Usuário não encontrado');
      }

      await saveActualUserModel(idUser: user.uid);

      return actualUserModel;
    } catch (e) {
      throw ('Erro ao retornar usuário atual: $e');
    }
  }

  Future saveActualUserModel({required String idUser}) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(idUser).get();
      if (snapshot.exists && snapshot.data() != null) {
        actualUserModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return null;
      } else {
        Exception("Documento não encontrado ou sem dados.");
      }
    } catch (e) {
      throw "Erro ao buscar usuário: $e";
    }
  }

  bool userHasPermission(
      {required BuildContext context, required UserModel user}) {
    String? actualRoute = ModalRoute.of(context)?.settings.name;
    if (!user.active) {
      return false;
    }
    switch (actualRoute) {
      case '/users':
        return user.manipulateUsers;
      case '/financial':
        return user.manipulateFinancial;
      case '/encounters':
        return user.manipulateEncounter;
      case '/circles':
        return user.manipulateCircles;
      case '/speakers':
        return user.manipulateEncounter;
      default:
        return true;
    }
  }
}
