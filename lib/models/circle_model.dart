class CircleModel {
  final String id;
  final int sequentialEncounter;
  final String name;
  final String colorHex;
  String? urlThemeImage;
  String? urlCircleImage;

  CircleModel({
    required this.id,
    required this.sequentialEncounter,
    required this.name,
    required this.colorHex,
    this.urlThemeImage,
    this.urlCircleImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sequentialEncounter': sequentialEncounter,
      'name': name,
      'colorHex': colorHex,
      'urlThemeImage': urlThemeImage,
      'urlCircleImage': urlCircleImage,
    };
  }

  factory CircleModel.fromJson(Map<String, dynamic> map) {
    return CircleModel(
      id: map['id'],
      sequentialEncounter: map['sequentialEncounter'],
      name: map['name'],
      colorHex: map['colorHex'],
      urlThemeImage: map['urlThemeImage'] ?? '',
      urlCircleImage: map['urlCircleImage'] ?? '',
    );
  }
}
