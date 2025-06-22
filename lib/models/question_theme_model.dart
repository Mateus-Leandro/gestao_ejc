class QuestionThemeModel {
  final String id;
  final String description;

  QuestionThemeModel({
    required this.id,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }

  factory QuestionThemeModel.fromJson(Map<String, dynamic> map) {
    return QuestionThemeModel(
      id: map['id'],
      description: map['description'],
    );
  }
}
