import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestao_ejc/models/userModel.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/user_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final UserService _userService = getIt<UserService>();

  Future<String?> entrarUsuario(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }

  Future<String?> cadastrarUsuario(
      {required UserModel user, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: password);
      User? newUser = userCredential.user;
      await newUser?.updateDisplayName(user.name);
      await newUser?.reload();

      if(newUser != null){
        user.userId = newUser.uid;
        _userService.addUser(user);
      }

    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }

  Future<String?> redefinicaoSenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return erroAuth(e);
    }
    return null;
  }

  Future<String?> deslogar() async {
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
}
