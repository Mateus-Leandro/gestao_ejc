import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/enums/circle_color_enum.dart';

class AnswerModel {
  final int sequentialEncounter;
  final String id;
  final DocumentReference referenceQuestion;
  final String answer;
  final CircleColorEnum circleColor;

  AnswerModel({
    required this.sequentialEncounter,
    required this.id,
    required this.referenceQuestion,
    required this.answer,
    required this.circleColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'sequentialEncounter': sequentialEncounter,
      'id': id,
      'referenceQuestion': referenceQuestion,
      'answer': answer,
      'hexColorCircle': circleColor.colorHex,
    };
  }

  factory AnswerModel.fromJson(Map<String, dynamic> map) {
    return AnswerModel(
      sequentialEncounter: map['sequentialEncounter'],
      id: map['id'],
      referenceQuestion: map['referenceQuestion'],
      answer: map['answer'],
      circleColor: CircleColorEnum.values.firstWhere(
        (color) => color.colorHex == map['hexColorCircle'],
      ),
    );
  }
}
