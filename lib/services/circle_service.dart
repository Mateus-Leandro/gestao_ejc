import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/models/circle_model.dart';

class CircleService {
  final String collection = 'circles';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  late Query query;
  late QuerySnapshot snapshot;
  var response;

  Future<String?> saveCircle({required CircleModel circle}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(circle.id)
          .set(circle.toJson());
      return null;
    } catch (e) {
      response = 'Erro ao salvar circulo $e';
      print(response);
      return response;
    }
  }

  Future getCircles(String? circleName) async {
    try {
      query = _firestore.collection(collection);
      if (circleName != null) {
        query = query.where('id', isGreaterThanOrEqualTo: circleName).where(
              'id',
              isLessThan: circleName.substring(0, circleName.length - 1) +
                  String.fromCharCode(
                      circleName.codeUnitAt(circleName.length - 1) + 1),
            );
      }
      snapshot = await query.get();
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

  Future<String?> deleteCircle({required String circleId}) async {
    try {
      await _firestore.collection(collection).doc(circleId).delete();
      return null;
    } catch (e) {
      var response = 'Erro ao excluir círculo $e';
      print(response);
      return response;
    }
  }
}
