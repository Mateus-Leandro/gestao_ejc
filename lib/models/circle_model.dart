class CircleModel {
  final String id;
  final String name;
  final String colorHex;

  CircleModel({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
    };
  }

  factory CircleModel.fromJson(Map<String, dynamic> map) {
    return CircleModel(
      id: map['id'],
      name: map['name'],
      colorHex: map['colorHex'],
    );
  }
}
