import 'package:gestao_ejc/enums/instrument_enum.dart';
import 'package:gestao_ejc/models/member_model.dart';
import 'package:gestao_ejc/models/uncle_model.dart';

abstract class AbstractPersonModel {
  final String id;
  String? urlImage;
  final String name;
  final String type;
  final String? instagram;
  final String? phone;
  final String? birthday;
  final String? ejcAccomplished;
  final String? eccAccomplished;
  final List<InstrumentEnum>? instruments;
  final String? cep;
  final String? street;
  final String? numberAdress;
  final String? apartment;
  final String? district;
  final String? city;

  AbstractPersonModel({
    required this.id,
    required this.urlImage,
    required this.name,
    required this.type,
    this.instagram,
    this.phone,
    this.birthday,
    this.ejcAccomplished,
    this.eccAccomplished,
    this.instruments,
    this.cep,
    this.street,
    this.numberAdress,
    this.apartment,
    this.district,
    this.city,
  });

  Map<String, dynamic> toJson();
  static AbstractPersonModel fromJson(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'member':
        return MemberModel.fromJson(map);
      case 'uncle':
        return UncleModel.fromJson(map);
      default:
        throw Exception('Tipo desconhecido: ${map['type']}');
    }
  }
}
