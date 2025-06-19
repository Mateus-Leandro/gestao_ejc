import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/team_member_model.dart';
import 'package:gestao_ejc/models/team_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class TeamMemberService {
  final String collectionPath = 'team_members';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  late QuerySnapshot snapshot;

  Future<void> saveTeamMember({required TeamMemberModel teamMember}) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(teamMember.id)
          .set(teamMember.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TeamMemberModel>> getTeamMembers(
      {required int sequentialEncounter}) async {
    try {
      snapshot = await _firestore
          .collection(collectionPath)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .get();
      return snapshot.docs
          .map(
            (doc) =>
                TeamMemberModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTeamMeber({required String teamMemberId}) async {
    try {
      await _firestore.collection(collectionPath).doc(teamMemberId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<TeamMemberModel?> getMemberCurrentTeam({
    required int sequentialEncounter,
    required DocumentReference referenceMember,
  }) async {
    try {
      snapshot = await _firestore
          .collection(collectionPath)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .where(
            'referenceMember',
            isEqualTo: referenceMember,
          )
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) =>
                TeamMemberModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList()
            .first;
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TeamMemberModel>?> getMemberByTeamAndEncounter(
      {required int sequentialEncounter, required TeamModel team}) async {
    try {
      final teamReference =
          FirebaseFirestore.instance.collection("teams").doc(team.id);
      snapshot = await _firestore
          .collection(collectionPath)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .where('referenceTeam', isEqualTo: teamReference)
          .get();
      return snapshot.docs
          .map((doc) =>
              TeamMemberModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
