import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/member_model.dart';
import 'package:gestao_ejc/models/uncle_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class PersonService {
  final String collectionPath = 'persons';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();

  Future<List<AbstractPersonModel>> getPersons() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(collectionPath).get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return _fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao obter pessoas: $e');
    }
  }

  Future<void> savePerson({required AbstractPersonModel person}) async {
    try {
      if (person is UncleModel) {
        await _firestore
            .collection(collectionPath)
            .doc(person.uncles.first.id)
            .set({
          'id': person.id,
          'name': person.name,
          'type': 'uncle',
          'uncles': person.uncles.map((uncle) => uncle.toJson()).toList(),
        });
      } else {
        await _firestore
            .collection(collectionPath)
            .doc(person.id)
            .set(person.toJson());
      }
    } catch (e) {
      throw Exception('Erro ao salvar pessoa: $e');
    }
  }

  Future<void> deletePerson({required String personId}) async {
    try {
      await _firestore.collection(collectionPath).doc(personId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar pessoa: $e');
    }
  }

  AbstractPersonModel _fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'member':
        return MemberModel.fromJson(map);
      case 'uncle':
        return UncleModel.fromJson(map);
      default:
        throw Exception("Tipo desconhecido: ${map['type']}");
    }
  }
}
