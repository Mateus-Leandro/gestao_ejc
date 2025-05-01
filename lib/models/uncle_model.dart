  import 'package:gestao_ejc/enums/instrument_enum.dart';
  import 'package:gestao_ejc/models/abstract_person_model.dart';

  class UncleModel extends AbstractPersonModel {
    final List<AbstractPersonModel> uncles;

  UncleModel({
    required super.id,
    required super.urlImage,
    required super.name,
    super.type = 'uncle',
    required this.uncles,
    super.instagram,
    super.phone,
    super.birthday,
    super.ejcAccomplished,
    super.eccAccomplished,
    super.instruments,
    super.cep,
    super.street,
    super.numberAdress,
    super.district,
    super.city,
    super.complement,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'urlImage': urlImage,
      'name': name,
      'type': type,
      'instagram': instagram,
      'phone': phone,
      'birthday': birthday,
      'ejcAccomplished': ejcAccomplished,
      'eccAccomplished': eccAccomplished,
      'instruments': instruments?.map((e) => e.toString()).toList(),
      'uncles': uncles.map((uncle) => uncle.toJson()).toList(),
      'cep': cep,
      'street': street,
      'numberAdress': numberAdress,
      'district': district,
      'city': city,
      'complement': complement,
    };
  }

  factory UncleModel.fromJson(Map<String, dynamic> map) {
    return UncleModel(
      id: map['id'],
      urlImage: map['urlImage'],
      name: map['name'],
      type: map['type'],
      instagram: map['instagram'],
      phone: map['phone'],
      birthday: map['birthday'],
      ejcAccomplished: map['ejcAccomplished'],
      eccAccomplished: map['eccAccomplished'],
      instruments: (map['instruments'] as List<dynamic>?)
          ?.map((e) => InstrumentEnumExtension.fromName(e as String))
          .toList(),
      cep: map['cep'] ?? '',
      street: map['street'] ?? '',
      numberAdress: map['numberAdress'] ?? '',
      district: map['district'] ?? '',
      city: map['city'] ?? '',
      uncles: (map['uncles'] as List<dynamic>?)
              ?.map((e) => AbstractPersonModel.fromJson(e))
              .toList() ??
          [],
      complement: map['complement'] ?? '',
    );
  }
}
