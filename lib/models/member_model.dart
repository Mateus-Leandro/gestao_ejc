import 'package:gestao_ejc/enums/instrument_enum.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';

class MemberModel extends AbstractPersonModel {
  MemberModel({
    required super.id,
    required super.name,
    required super.type,
    super.instagram,
    super.phone,
    super.birthday,
    super.ejcAccomplished,
    super.eccAccomplished,
    super.instruments,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'instagram': instagram,
      'phone': phone,
      'birthday': birthday,
      'ejcAccomplished': ejcAccomplished,
      'eccAccomplished': eccAccomplished,
      'instruments':
          instruments?.map((instrument) => instrument.instrumentName).toList(),
    };
  }

  factory MemberModel.fromJson(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'],
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
    );
  }
}
