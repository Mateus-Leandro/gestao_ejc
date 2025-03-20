import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/enums/circle_color_enum.dart';
import 'package:gestao_ejc/models/answer_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class AnswerService {
  final String collection = 'answers';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  QuerySnapshot? snapshot;

  Future<void> saveAnswer({required AnswerModel answer}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(answer.id)
          .set(answer.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AnswerModel>> getAnswers({
    required int sequentialEncounter,
  }) async {
    try {
      snapshot = await _firestore
          .collection(collection)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .get();

      return snapshot!.docs
          .map(
            (doc) => AnswerModel.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAnswer({required AnswerModel answer}) async {
    try {
      await _firestore.collection(collection).doc(answer.id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> alreadyAnswered({required AnswerModel answer}) async {
    try {
      snapshot = await _firestore
          .collection(collection)
          .where('sequentialEncounter', isEqualTo: answer.sequentialEncounter)
          .where('hexColorCircle', isEqualTo: answer.circleColor.colorHex)
          .where('referenceQuestion', isEqualTo: answer.referenceQuestion)
          .get();
      return snapshot!.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
