import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/models/circle_model.dart';

class CircleService {
  final String collection = 'circles';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  late Query query;
  late QuerySnapshot snapshot;
  var response;

  Future<void> saveCircle({required CircleModel circle}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(circle.id)
          .set(circle.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CircleModel>> getCircles(int sequentialEncounter) async {
    try {
      query = _firestore
          .collection(collection)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter);
      snapshot = await query.get();
      return snapshot.docs
          .map(
            (doc) => CircleModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCircle({required String circleId}) async {
    try {
      await _firestore.collection(collection).doc(circleId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUrlImages({required CircleModel circle}) async {
    try {
      await _firestore.collection(collection).doc(circle.id).update({
        'urlCircleImage': circle.urlCircleImage,
        'urlThemeImage': circle.urlThemeImage,
      });
    } catch (e) {
      rethrow;
    }
  }
}
