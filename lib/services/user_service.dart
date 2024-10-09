import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/user_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class UserService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  Future<List<UserModel>> getUsers(String? userName) async {
    try {
      QuerySnapshot snapshot;
      if (userName == null) {
        snapshot = await _firestore.collection('users').get();
      } else {
        snapshot = await _firestore
            .collection('users')
            .where('nameLowerCase', isGreaterThanOrEqualTo: userName)
            .where(
              'nameLowerCase',
              isLessThan: userName.substring(0, userName.length - 1) +
                  String.fromCharCode(
                      userName.codeUnitAt(userName.length - 1) + 1),
            )
            .get();
      }

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erro ao buscar usuários: $e");
      return [];
    }
  }

  Future<String?> saveUser(UserModel newUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(newUser.id)
          .set(newUser.toJson());
      return null;
    } catch (e) {
      return 'Erro ao salvar usuário: $e';
    }
  }
}
