import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/question_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class QuestionService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final String collectionPath = 'questions';

  Future<List<QuestionModel>> getQuestions(
      {required int sequentialEncounter}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionPath)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .get();
      return snapshot.docs
          .map((doc) =>
              QuestionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveQuestion({required QuestionModel question}) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(question.id)
          .set(question.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteQuestion({required QuestionModel question}) async {
    try {
      await _firestore.collection(collectionPath).doc(question.id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
