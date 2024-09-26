class UserModel {
  UserModel({
    required this.birthday,
    required this.email,
    required this.name,
    required this.manipulateAdministrator,
    required this.manipulateCircles,
    required this.manipulateEncounter,
    required this.manipulateExport,
    required this.manipulateFinancial,
    required this.manipulateImport,
    required this.manipulateMembers,
    required this.manipulateUsers,
    required this.activeUser,
  });

  final String birthday;
  final String email;
  final String name;
  final bool manipulateAdministrator;
  final bool manipulateCircles;
  final bool manipulateEncounter;
  final bool manipulateExport;
  final bool manipulateFinancial;
  final bool manipulateImport;
  final bool manipulateMembers;
  final bool manipulateUsers;
  final bool activeUser;

  Map<String, dynamic> toJson() {
    return {
      'birthday': birthday,
      'email': email,
      'name': name,
      'manipulateAdministrator': manipulateAdministrator,
      'manipulateCircles': manipulateCircles,
      'manipulateEncounter': manipulateEncounter,
      'manipulateExport': manipulateExport,
      'manipulateFinancial': manipulateFinancial,
      'manipulateImport': manipulateImport,
      'manipulateMembers': manipulateMembers,
      'activeUser': activeUser,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      birthday: map['birthday'],
      email: map['email'],
      name: map['name'],
      manipulateAdministrator: map['manipulateAdministrator'],
      manipulateCircles: map['manipulateCircles'],
      manipulateEncounter: map['manipulateEncounter'],
      manipulateExport: map['manipulateExport'],
      manipulateFinancial: map['manipulateFinancial'],
      manipulateImport: map['manipulateImport'],
      manipulateMembers: map['manipulateMembers'],
      manipulateUsers: map['manipulateUsers'],
      activeUser: map['activeUser'],
    );
  }
}
