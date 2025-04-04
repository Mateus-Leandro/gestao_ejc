class UserModel {
  String? id;
  bool active;
  final String name;
  final String nameLowerCase;
  final String email;
  final String birthday;
  final bool manipulateAdministrator;
  final bool manipulateCircles;
  final bool manipulateEncounter;
  final bool manipulateExport;
  final bool manipulateFinancial;
  final bool manipulateImport;
  final bool manipulateMembers;
  final bool manipulateUsers;

  UserModel({
    this.id,
    required this.active,
    required this.name,
    required this.nameLowerCase,
    required this.email,
    required this.birthday,
    required this.manipulateAdministrator,
    required this.manipulateCircles,
    required this.manipulateEncounter,
    required this.manipulateExport,
    required this.manipulateFinancial,
    required this.manipulateImport,
    required this.manipulateMembers,
    required this.manipulateUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      'name': name,
      'nameLowerCase': nameLowerCase,
      'email': email,
      'birthday': birthday,
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
