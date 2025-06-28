import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/circle_member_model.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleMemberService {
  final String collectionPath = 'circle_members';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  late Query query;
  late QuerySnapshot snapshot;
  var response;

  Future<List<CircleMemberModel>> getCircleMembers(
      {required int sequentialEncounter}) async {
    try {
      snapshot = await _firestore
          .collection(collectionPath)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .orderBy('circulist', descending: true)
          .get();
      return snapshot.docs
          .map(
            (doc) =>
                CircleMemberModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveCircleMember(
      {required CircleMemberModel circleMember}) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(circleMember.id)
          .set(circleMember.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCircleMember(
      {required CircleMemberModel circleMember}) async {
    try {
      await _firestore.collection(collectionPath).doc(circleMember.id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CircleMemberModel>?> getMemberByTeamAndEncounter(
      {required int sequentialEncounter, required CircleModel circle}) async {
    try {
      final circleReference =
          FirebaseFirestore.instance.collection("circles").doc(circle.id);
      snapshot = await _firestore
          .collection(collectionPath)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .where('referenceCircle', isEqualTo: circleReference)
          .orderBy('circulist', descending: true)
          .get();
      return snapshot.docs
          .map((doc) =>
              CircleMemberModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<CircleMemberModel?> getMemberCurrentCircle({
    required int sequentialEncounter,
    required DocumentReference referenceMember,
  }) async {
    try {
      snapshot = await _firestore
          .collection(collectionPath)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .where(
            'referenceMember',
            isEqualTo: referenceMember,
          )
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) =>
                CircleMemberModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList()
            .first;
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }
}
