import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/speaker_couple_model.dart';
import 'package:gestao_ejc/models/speaker_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class SpeakerService {
  final String collectionPath = 'speakers';
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();

  Future<List<AbstractSpeakerModel>> getSpeakers() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(collectionPath).get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AbstractSpeakerModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao obter palestrantes: $e');
    }
  }

  Future<void> saveSpeaker({required AbstractSpeakerModel speaker}) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(speaker.id)
          .set(speaker.toJson());
    } catch (e) {
      throw Exception('Erro ao salvar palestrante: $e');
    }
  }

  Future<void> deleteSpeaker({required String speakerId}) async {
    try {
      await _firestore.collection(collectionPath).doc(speakerId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar palestrante: $e');
    }
  }

  Future<void> updateUrlImage({required AbstractSpeakerModel speaker}) async {
    try {
      await _firestore.collection(collectionPath).doc(speaker.id).update({
        'urlImage': speaker.urlImage,
      });

      if (speaker is SpeakerCoupleModel) {
        await _firestore.collection(collectionPath).doc(speaker.id).update({
          'uncle.urlImage': speaker.uncle.urlImage,
          'aunt.urlImage': speaker.aunt.urlImage,
        });
      }
    } catch (e) {
      throw Exception('Erro ao atualizar imagem: $e');
    }
  }
}
