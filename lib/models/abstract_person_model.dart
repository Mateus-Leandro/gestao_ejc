abstract class AbstractPersonModel {
  String? id;
  final bool active;
  final String name;
  final String email;
  final String birthday;

  AbstractPersonModel({
    this.id,
    required this.active,
    required this.name,
    required this.email,
    required this.birthday,
  });

  Map<String, dynamic> toJson();
}
