import 'package:gestao_ejc/enums/circle_color_enum.dart';

class CircleModel {
  final String id;
  final int sequentialEncounter;
  final String name;
  final CircleColorEnum color;
  String? urlThemeImage;
  String? urlCircleImage;

  CircleModel({
    required this.id,
    required this.sequentialEncounter,
    required this.name,
    required this.color,
    this.urlThemeImage,
    this.urlCircleImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sequentialEncounter': sequentialEncounter,
      'name': name,
      'colorHex': color.colorHex,
      'urlThemeImage': urlThemeImage,
      'urlCircleImage': urlCircleImage,
    };
  }

  factory CircleModel.fromJson(Map<String, dynamic> map) {
    return CircleModel(
      id: map['id'],
      sequentialEncounter: map['sequentialEncounter'],
      name: map['name'],
      color: CircleColorEnum.values.firstWhere(
        (color) => color.colorHex == map['colorHex'],
      ),
      urlThemeImage: map['urlThemeImage'] ?? '',
      urlCircleImage: map['urlCircleImage'] ?? '',
    );
  }
}
