class UserModel {
  UserModel({
    required this.activeUser,
    required this.birthday,
    required this.email,
    required this.manipulateAdministrator,
    required this.manipulateCircles,
    required this.manipulateEncounter,
    required this.manipulateExport,
    required this.manipulateFinancial,
    required this.manipulateImport,
    required this.manipulateMembers,
    required this.manipulateUsers,
    required this.name,
    required this.userId,
  });

  final bool activeUser;
  final String birthday;
  final String email;
  final bool manipulateAdministrator;
  final bool manipulateCircles;
  final bool manipulateEncounter;
  final bool manipulateExport;
  final bool manipulateFinancial;
  final bool manipulateImport;
  final bool manipulateMembers;
  final bool manipulateUsers;
  final String name;
  String userId;

  Map<String, dynamic> toJson() {
    return {
      'activeUser': activeUser,
      'birthday': birthday,
      'email': email,
      'manipulateAdministrator': manipulateAdministrator,
      'manipulateCircles': manipulateCircles,
      'manipulateEncounter': manipulateEncounter,
      'manipulateExport': manipulateExport,
      'manipulateFinancial': manipulateFinancial,
      'manipulateImport': manipulateImport,
      'manipulateMembers': manipulateMembers,
      'manipulateUsers': manipulateUsers,
      'name': name,
      'userId' : userId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      activeUser: map['activeUser'],
      birthday: map['birthday'],
      email: map['email'],
      manipulateAdministrator: map['manipulateAdministrator'],
      manipulateCircles: map['manipulateCircles'],
      manipulateEncounter: map['manipulateEncounter'],
      manipulateExport: map['manipulateExport'],
      manipulateFinancial: map['manipulateFinancial'],
      manipulateImport: map['manipulateImport'],
      manipulateMembers: map['manipulateMembers'],
      manipulateUsers: map['manipulateUsers'],
      name: map['name'],
      userId: map['userId'],
    );
  }
}
