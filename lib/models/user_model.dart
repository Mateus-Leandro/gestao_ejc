import 'package:gestao_ejc/models/abstract_person_model.dart';

class UserModel extends AbstractPersonModel {
  final bool manipulateAdministrator;
  final bool manipulateCircles;
  final bool manipulateEncounter;
  final bool manipulateExport;
  final bool manipulateFinancial;
  final bool manipulateImport;
  final bool manipulateMembers;
  final bool manipulateUsers;

  UserModel({
    super.id,
    required super.active,
    required super.name,
    required super.nameLowerCase,
    required super.email,
    required super.birthday,
    required this.manipulateAdministrator,
    required this.manipulateCircles,
    required this.manipulateEncounter,
    required this.manipulateExport,
    required this.manipulateFinancial,
    required this.manipulateImport,
    required this.manipulateMembers,
    required this.manipulateUsers,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'active': super.active,
      'name': super.name,
      'nameLowerCase': super.nameLowerCase,
      'email': super.email,
      'birthday': super.birthday,
      'manipulateAdministrator': manipulateAdministrator,
      'manipulateCircles': manipulateCircles,
      'manipulateEncounter': manipulateEncounter,
      'manipulateExport': manipulateExport,
      'manipulateFinancial': manipulateFinancial,
      'manipulateImport': manipulateImport,
      'manipulateMembers': manipulateMembers,
      'manipulateUsers': manipulateUsers,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      active: map['active'] ?? true,
      name: map['name'] ?? '',
      nameLowerCase: map['nameLowerCase'] ?? '',
      email: map['email'] ?? '',
      birthday: map['birthday'] ?? '',
      manipulateAdministrator: map['manipulateAdministrator'] ?? false,
      manipulateCircles: map['manipulateCircles'] ?? false,
      manipulateEncounter: map['manipulateEncounter'] ?? false,
      manipulateExport: map['manipulateExport'] ?? false,
      manipulateFinancial: map['manipulateFinancial'] ?? false,
      manipulateImport: map['manipulateImport'] ?? false,
      manipulateMembers: map['manipulateMembers'] ?? false,
      manipulateUsers: map['manipulateUsers'] ?? false,
    );
  }
}
