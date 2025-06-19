import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/enums/circle_color_enum.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/models/circle_model.dart';

class CircleService {
  final String collectionPath = 'circles';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  late Query query;
  late QuerySnapshot snapshot;
  var response;

  Future<void> saveCircle({required CircleModel circle}) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(circle.id)
          .set(circle.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CircleModel>> getCircles(int sequentialEncounter) async {
    try {
      query = _firestore
          .collection(collectionPath)
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
      await _firestore.collection(collectionPath).doc(circleId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUrlImages({required CircleModel circle}) async {
    try {
      await _firestore.collection(collectionPath).doc(circle.id).update({
        'urlCircleImage': circle.urlCircleImage,
        'urlThemeImage': circle.urlThemeImage,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentReference?> referenceCircleByTypeAndEncounter(
      {required CircleColorEnum circle,
      required int sequentialEncounter}) async {
    try {
      snapshot = await _firestore
          .collection(collectionPath)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .where('colorHex', isEqualTo: circle.colorHex)
          .get();
      return snapshot.docs.isNotEmpty ? snapshot.docs.first.reference : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<CircleModel> circleByReference(
      {required DocumentReference referenceCircle}) async {
    try {
      final circleByReference = await referenceCircle.get();
      return CircleModel.fromJson(
        circleByReference.data() as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}
