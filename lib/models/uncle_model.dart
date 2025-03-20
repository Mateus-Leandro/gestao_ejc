import 'package:gestao_ejc/models/abstract_person_model.dart';

class UncleModel extends AbstractPersonModel {
  final List<AbstractPersonModel> uncles;

  UncleModel({
    required String id,
    required String name,
    required this.uncles,
  }) : super(id: id, name: name, type: 'uncle');

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'uncles': uncles.map((uncle) => uncle.toJson()).toList(),
    };
  }

  factory UncleModel.fromJson(Map<String, dynamic> map) {
    return UncleModel(
      id: map['id'],
      name: map['name'],
      uncles: (map['uncles'] as List<dynamic>?)
              ?.map((e) => AbstractPersonModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
