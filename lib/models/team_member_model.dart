import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/team_model.dart';

class TeamMemberModel {
  final String id;
  final int sequentialEncounter;
  final bool leader;
  final DocumentReference referenceMember;
  final DocumentReference referenceTeam;
  late AbstractPersonModel member;
  late TeamModel team;

  TeamMemberModel({
    required this.id,
    required this.leader,
    required this.sequentialEncounter,
    required this.referenceMember,
    required this.referenceTeam,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leader': leader,
      'sequentialEncounter': sequentialEncounter,
      'referenceMember': referenceMember,
      'referenceTeam': referenceTeam,
    };
  }

  factory TeamMemberModel.fromJson(Map<String, dynamic> map) {
    return TeamMemberModel(
      id: map['id'],
      leader: map['leader'] ?? false,
      sequentialEncounter: map['sequentialEncounter'],
      referenceMember: map['referenceMember'],
      referenceTeam: map['referenceTeam'],
    );
  }
}
