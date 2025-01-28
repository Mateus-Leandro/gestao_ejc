import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  final int sequentialEncounter;
  final String id;
  final DocumentReference referenceQuestion;
  final String answer;
  final String hexColorCircle;

  AnswerModel({
    required this.sequentialEncounter,
    required this.id,
    required this.referenceQuestion,
    required this.answer,
    required this.hexColorCircle,
  });

  Map<String, dynamic> toJson() {
    return {
      'sequentialEncounter': sequentialEncounter,
      'id': id,
      'referenceQuestion': referenceQuestion,
      'answer': answer,
      'hexColorCircle': hexColorCircle,
    };
  }

  factory AnswerModel.fromJson(Map<String, dynamic> map) {
    return AnswerModel(
      sequentialEncounter: map['sequentialEncounter'],
      id: map['id'],
      referenceQuestion: map['referenceQuestion'],
      answer: map['answer'],
      hexColorCircle: map['hexColorCircle'],
    );
  }
}
