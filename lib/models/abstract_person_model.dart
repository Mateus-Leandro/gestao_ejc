abstract class AbstractPersonModel {
  String? id;
  bool active;
  final String name;
  final String nameLowerCase;
  final String email;
  final String birthday;

  AbstractPersonModel({
    this.id,
    required this.active,
    required this.name,
    required this.nameLowerCase,
    required this.email,
    required this.birthday,
  });

  Map<String, dynamic> toJson();
}
