import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/userModel.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class UserService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();

  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erro ao buscar usuários: $e");
      return [];
    }
  }

  Future<void> addUser(UserModel newUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(newUser.userId)
          .set(newUser.toJson());
    } catch (e) {
      print('Erro ao adicionar usuário: $e');
    }
  }
}
