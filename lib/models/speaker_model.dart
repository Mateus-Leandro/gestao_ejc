import 'package:gestao_ejc/models/speaker_couple_model.dart';

abstract class AbstractSpeakerModel {
  final String id;
  String? urlImage;
  final String name;
  final String? phone;
  final String? cep;
  final String? street;
  final String? numberAdress;
  final String? apartment;
  final String? district;
  final String? city;
  final String? reference;

  AbstractSpeakerModel({
    required this.id,
    required this.urlImage,
    required this.name,
    this.phone,
    this.cep,
    this.street,
    this.numberAdress,
    this.apartment,
    this.district,
    this.city,
    this.reference,
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
    super.cep,
    super.street,
    super.numberAdress,
    super.apartment,
    super.district,
    super.city,
    super.reference,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'urlImage': urlImage,
      'name': name,
      'type': type,
      'phone': phone,
      'couple': false,
      'cep': cep,
      'street': street,
      'numberAdress': numberAdress,
      'apartment': apartment,
      'district': district,
      'city': city,
      'reference': reference,
    };
  }

  factory SpeakerModel.fromJson(Map<String, dynamic> map) {
    return SpeakerModel(
      id: map['id'],
      urlImage: map['urlImage'] ?? '',
      name: map['name'],
      type: map['type'] ?? 'speaker',
      phone: map['phone'] ?? '',
      cep: map['cep'] ?? '',
      street: map['street'] ?? '',
      numberAdress: map['numberAdress'] ?? '',
      apartment: map['apartment'] ?? '',
      district: map['district'] ?? '',
      city: map['city'] ?? '',
      reference: map['reference'] ?? '',
    );
  }
}
