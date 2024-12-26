import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class EncounterService {
  final String collection = 'encounter';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
  late Query query;
  late QuerySnapshot snapshot;

  Future<List<EncounterModel>> getEncounter() async {
    try {
      query = _firestore.collection(collection).orderBy('sequential');
      snapshot = await query.get();
      return snapshot.docs
          .map((doc) =>
              EncounterModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveEncounter({required EncounterModel encounter}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(functionIntToRoman.convert(encounter.sequential))
          .set(encounter.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEncounter({required EncounterModel encounter}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(encounter.sequential.toString())
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getLastSequentialEncounter() async {
    int lastEncounter = 0;
    try {
      query = _firestore
          .collection(collection)
          .orderBy('sequential', descending: true)
          .limit(1);
      snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        lastEncounter = snapshot.docs.first['sequential'] as int;
      }
      return lastEncounter;
    } catch (e) {
      rethrow;
    }
  }
}
