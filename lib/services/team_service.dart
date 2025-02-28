import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/team_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class TeamService extends ChangeNotifier {
  final String collection = 'teams';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  late Query query;
  late QuerySnapshot snapshot;

  Future<List<TeamModel>> getTeams({required int sequentialEncounter}) async {
    try {
      query = _firestore
          .collection(collection)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter)
          .orderBy('type');
      snapshot = await query.get();
      return snapshot.docs
          .map((doc) => TeamModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveTeam({required TeamModel team}) async {
    try {
      await _firestore.collection(collection).doc(team.id).set(team.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTeam({required TeamModel team}) async {
    try {
      await _firestore.collection(collection).doc(team.id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUrlImage({required TeamModel team}) async {
    try {
      await _firestore.collection(collection).doc(team.id).update({
        'urlImage': team.urlImage,
      });
    } catch (e) {
      rethrow;
    }
  }
}
