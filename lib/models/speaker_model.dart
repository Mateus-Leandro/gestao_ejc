import 'package:gestao_ejc/models/speaker_couple_model.dart';

abstract class AbstractSpeakerModel {
  final String id;
  String? urlImage;
  final String name;
  final String? phone;
  final String? instagram;

  AbstractSpeakerModel({
    required this.id,
    required this.urlImage,
    required this.name,
    this.phone,
    this.instagram,
  });

  Map<String, dynamic> toJson();

  static AbstractSpeakerModel fromJson(Map<String, dynamic> map) {
    if (map.containsKey('couple') && map['couple'] == true) {
      return SpeakerCoupleModel.fromJson(map);
    } else {
      return SpeakerModel.fromJson(map);
    }
  }
}

class SpeakerModel extends AbstractSpeakerModel {
  String type; // Novo campo para identificar o tipo (speaker, uncle, aunt)

  SpeakerModel({
    required super.id,
    required super.urlImage,
    required super.name,
    this.type = 'speaker', // Valor padrão é 'speaker'
    super.phone,
    super.instagram,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'urlImage': urlImage,
      'name': name,
      'type': type,
      'phone': phone,
      'instagram': instagram,
      'couple': false,
    };
  }

  factory SpeakerModel.fromJson(Map<String, dynamic> map) {
    return SpeakerModel(
      id: map['id'],
      urlImage: map['urlImage'] ?? '',
      name: map['name'],
      type: map['type'] ?? 'speaker',
      phone: map['phone'] ?? '',
      instagram: map['instagram'] ?? '',
    );
  }
}
