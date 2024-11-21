class CircleModel {
  final String id;
  final String name;
  final String colorHex;
  final int minMembers;
  final int maxMembers;

  CircleModel({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.minMembers,
    required this.maxMembers,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
      'minMembers': minMembers,
      'maxMembers': maxMembers,
    };
  }

  factory CircleModel.fromJson(Map<String, dynamic> map) {
    return CircleModel(
      id: map['id'],
      name: map['name'],
      colorHex: map['colorHex'],
      minMembers: map['minMembers'],
      maxMembers: map['maxMembers'],
    );
  }
}
