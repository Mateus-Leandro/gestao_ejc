import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/user_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final UserService _userService = getIt<UserService>();
  late final UserModel _actualUser;
  late final String _passwordActualUser;

  Future<String?> logIn(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    _saveActualUser(senha);
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
        user.userId = newUser.uid;
        _userService.saveUser(user);
        logIn(email: _actualUser.email, senha: _passwordActualUser);
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

  void _saveActualUser(String senha) async {
    final _user = _firebaseAuth.currentUser;
    _actualUser = (await _userService.getActualUser(idUser: _user!.uid))!;
    _passwordActualUser = senha;
  }
}
