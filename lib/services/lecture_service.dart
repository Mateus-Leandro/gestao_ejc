import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/lecture_model.dart';
import 'package:gestao_ejc/models/speaker_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class LectureService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final String collectionPath = 'lectures';
  final String speakersCollectionPath = 'speakers';

  Future<List<LectureModel>> getLectures({
    required int sequentialEncounter,
    String? lectureName,
  }) async {
    try {
      Query query = _firestore
          .collection(collectionPath)
          .where('sequentialEncounter', isEqualTo: sequentialEncounter);

      if (lectureName != null && lectureName.isNotEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: lectureName)
            .where('name', isLessThanOrEqualTo: '$lectureName\uf8ff');
      }

      QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) =>
              LectureModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao obter palestras: $e');
    }
  }

  Future<List<LectureModel>> getLecturesBySpeaker(String speakerId) async {
    try {
      // Cria uma referência do documento do palestrante
      DocumentReference speakerRef =
          _firestore.collection(speakersCollectionPath).doc(speakerId);

      // Busca todas as palestras que têm referência a este palestrante
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionPath)
          .where('referenceSpeaker', isEqualTo: speakerRef)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              LectureModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar palestras do palestrante: $e');
    }
  }

  Future<void> removeSpeakerFromLectures(String speakerId) async {
    try {
      // Primeiro, busca todas as palestras com este palestrante
      DocumentReference speakerRef =
          _firestore.collection(speakersCollectionPath).doc(speakerId);
      QuerySnapshot lecturesWithSpeaker = await _firestore
          .collection(collectionPath)
          .where('referenceSpeaker', isEqualTo: speakerRef)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in lecturesWithSpeaker.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao remover palestrante das palestras: $e');
    }
  }

  Future<void> saveLecture({required LectureModel lecture}) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(lecture.id)
          .set(lecture.toJson());
    } catch (e) {
      throw Exception('Erro ao salvar palestra: $e');
    }
  }

  Future<void> deleteLecture({required LectureModel lecture}) async {
    try {
      await _firestore.collection(collectionPath).doc(lecture.id).delete();
    } catch (e) {
      throw Exception('Erro ao excluir palestra: $e');
    }
  }

  Future<AbstractSpeakerModel?> getSpeakerById(String speakerId) async {
    try {
      DocumentSnapshot speakerDoc = await _firestore
          .collection(speakersCollectionPath)
          .doc(speakerId)
          .get();

      if (!speakerDoc.exists) {
        return null;
      }

      return AbstractSpeakerModel.fromJson(
          speakerDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erro ao buscar palestrante: $e');
    }
  }

  Future<DocumentReference> getSpeakerReference(
      DocumentReference referenceSpeaker) async {
    final speakerByReference = await referenceSpeaker.get();

    if (speakerByReference.exists) {
      return referenceSpeaker;
    } else {
      throw Exception('Palestrante não encontrado');
    }
  }
}
