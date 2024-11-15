import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/models/circle_model.dart';

class CircleService {
  final String collection = 'circle';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  late Query query;
  late QuerySnapshot snapshot;

  Future<bool> saveCircle({required CircleModel circle}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(circle.id)
          .set(circle.toJson());
      return true;
    } catch (e) {
      print('Erro ao salvar circulo;');
      return false;
    }
  }

  Future getAllCircles() async {
    try {
      snapshot = await _firestore.collection(collection).get();
      return snapshot.docs
          .map(
            (doc) => CircleModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Erro ao pesquisar circulos $e');
      return null;
    }
  }

  Future<bool> deleteCircle({required String circleId}) async {
    try {
      await _firestore.collection(collection).doc(circleId).delete();
      return true;
    } catch (e) {
      print('Erro ao excluir círculo $e');
      return false;
    }
  }
}
