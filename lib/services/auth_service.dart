import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();

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
      {required String email,
      required String senha,
      required String nome}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);
      User? newUser = userCredential.user;
      await newUser?.updateDisplayName(nome);
      await newUser?.reload();
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
