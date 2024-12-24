import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/circle_member_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleMemberService {
  final String collection = 'circle_members';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  late Query query;
  late QuerySnapshot snapshot;
  var response;

  Future getCircleMembers() async {
    try {
      snapshot = await _firestore.collection(collection).get();
      return snapshot.docs
          .map(
            (doc) =>
                CircleMemberModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao retornar membros';
    }
  }

  Future<bool> saveCircleMember(
      {required CircleMemberModel circleMember}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(circleMember.idCircleMember)
          .set(circleMember.toJson());
      return true;
    } catch (e) {
      throw 'Erro ao salvar membro: $e';
    }
  }

  Future<bool> deleteCircleMember(
      {required CircleMemberModel circleMember}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(circleMember.idCircleMember)
          .delete();
      return true;
    } catch (e) {
      throw 'Erro ao deleter membro $e';
    }
  }
}
