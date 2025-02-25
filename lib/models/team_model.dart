import 'package:gestao_ejc/enums/team_type_enum.dart';

class TeamModel {
  final int sequentialEncounter;
  final String id;
  final TeamTypeEnum type;
  final String urlImage;

  TeamModel({
    required this.sequentialEncounter,
    required this.id,
    required this.urlImage,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'sequentialEncounter': sequentialEncounter,
      'id': id,
      'type': type.formattedName,
      'urlImage': urlImage,
    };
  }

  factory TeamModel.fromJson(Map<String, dynamic> map) {
    return TeamModel(
      sequentialEncounter: map['sequentialEncounter'],
      id: map['id'],
      type: TeamTypeEnum.values.firstWhere(
        (type) => type.formattedName == map['type'],
      ),
      urlImage: map['urlImage'] ?? '',
    );
  }
}
