import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/question_theme_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class QuestionThemeService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final String collectionPath = 'question_themes';

  Future<List<QuestionThemeModel>> getQuestionThemes(
      String? themeDescription) async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(collectionPath).get();
      return snapshot.docs
          .map((doc) =>
              QuestionThemeModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveQuestionTheme({required QuestionThemeModel question}) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(question.id)
          .set(question.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteQuestionTheme(
      {required QuestionThemeModel question}) async {
    try {
      await _firestore.collection(collectionPath).doc(question.id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
