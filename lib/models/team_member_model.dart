import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/team_model.dart';

class TeamMemberModel {
  final String id;
  final int sequentialEncounter;
  final DocumentReference referenceMember;
  final DocumentReference referenceTeam;
  late AbstractPersonModel member;
  late TeamModel team;

  TeamMemberModel({
    required this.id,
    required this.sequentialEncounter,
    required this.referenceMember,
    required this.referenceTeam,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sequentialEncounter': sequentialEncounter,
      'referenceMember': referenceMember,
      'referenceTeam': referenceTeam,
    };
  }

  factory TeamMemberModel.fromJson(Map<String, dynamic> map) {
    return TeamMemberModel(
      id: map['id'],
      sequentialEncounter: map['sequentialEncounter'],
      referenceMember: map['referenceMember'],
      referenceTeam: map['referenceTeam'],
    );
  }
}
