class MemberModel {
  final String id;
  final String name;
  final String instagram;
  final String phone;
  final String birthday;
  final String encounter;

  MemberModel({
    required this.id,
    required this.name,
    required this.instagram,
    required this.phone,
    required this.birthday,
    required this.encounter,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'instagram': instagram,
      'phone': phone,
      'birthday': birthday,
      'encounter': encounter,
    };
  }

  factory MemberModel.fromJson(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'],
      name: map['name'],
      instagram: map['instagram'],
      phone: map['phone'],
      birthday: map['birthday'],
      encounter: map['encounter'],
    );
  }
}
