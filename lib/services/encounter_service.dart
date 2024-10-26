import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class EncounterService {
  final String collection = 'encounter';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();

  Future getEncounter() async {
    try {
      Query query = _firestore.collection(collection).orderBy('sequential');
      QuerySnapshot snapshot = await query.get();
      return snapshot.docs
          .map((doc) =>
              EncounterModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao pesquisar encontros $e');
      return null;
    }
  }

  Future<bool> saveEncounter({required EncounterModel encounter}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(encounter.sequential.toString())
          .set(encounter.toJson());
      return true;
    } catch (e) {
      print('Erro ao salvar encontro: $e');
      return false;
    }
  }

  Future<bool> deleteEncounter({required EncounterModel encounter}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(encounter.sequential.toString())
          .delete();
      return true;
    } catch (e) {
      print('Erro ao excluir encontro: $e');
      return false;
    }
  }
}
