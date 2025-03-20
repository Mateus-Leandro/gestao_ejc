class QuestionModel {
  final String id;
  final String question;
  final int sequentialEncounter;

  QuestionModel({
    required this.id,
    required this.question,
    required this.sequentialEncounter,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'sequentialEncounter': sequentialEncounter,
    };
  }

  factory QuestionModel.fromJson(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'],
      question: map['question'],
      sequentialEncounter: map['sequentialEncounter'],
    );
  }
}
