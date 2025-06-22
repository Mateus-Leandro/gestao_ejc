import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/question_theme_model.dart';

class QuestionModel {
  final String id;
  DocumentReference? referenceTheme;
  final String question;
  final int sequentialEncounter;
  QuestionThemeModel? theme;

  QuestionModel({
    required this.id,
    this.referenceTheme,
    required this.question,
    required this.sequentialEncounter,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referenceTheme': referenceTheme,
      'question': question,
      'sequentialEncounter': sequentialEncounter,
    };
  }

  factory QuestionModel.fromJson(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'],
      referenceTheme: map['referenceTheme'],
      question: map['question'],
      sequentialEncounter: map['sequentialEncounter'],
    );
  }
}
