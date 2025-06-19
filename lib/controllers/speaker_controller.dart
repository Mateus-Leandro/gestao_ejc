import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gestao_ejc/models/lecture_model.dart';
import 'package:gestao_ejc/models/speaker_couple_model.dart';
import 'package:gestao_ejc/models/speaker_model.dart';
import 'package:gestao_ejc/services/firebase_storage_service.dart';
import 'package:gestao_ejc/services/lecture_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/speaker_service.dart';

class SpeakerController extends ChangeNotifier {
  final SpeakerService _speakerService = getIt<SpeakerService>();
  final LectureService _lectureService = getIt<LectureService>();
  final FirebaseStorageService firebaseStorageService =
      getIt<FirebaseStorageService>();

  var _streamController;
  Stream<List<AbstractSpeakerModel>>? get stream => _streamController.stream;

  void init() {
    _streamController = StreamController<List<AbstractSpeakerModel>>();
    getSpeakers();
  }

  @override
  void dispose() {
    if (!_streamController.isClosed) {
      _streamController.close();
    }
    super.dispose();
  }

  Future<void> getSpeakers() async {
    try {
      final speakers = await _speakerService.getSpeakers();
      _streamController.sink.add(speakers);
    } catch (e) {
      _streamController.addError('Erro ao listar palestrantes: $e');
    }
  }

  Future<void> saveSpeaker({required AbstractSpeakerModel speaker}) async {
    try {
      await _speakerService.saveSpeaker(speaker: speaker);
      getSpeakers();
    } catch (e) {
      debugPrint('Erro ao salvar palestrante: $e');
      throw Exception('Erro ao salvar palestrante: $e');
    }
  }

  // Método atualizado para deletar palestrante e suas associações
  Future<void> deleteSpeaker({required AbstractSpeakerModel speaker}) async {
    try {
      // Primeiro, remover o palestrante de todas as palestras
      await _lectureService.removeSpeakerFromLectures(speaker.id);

      // Depois, deletar as imagens associadas ao palestrante
      if (speaker is SpeakerModel) {
        if (speaker.urlImage != null && speaker.urlImage!.isNotEmpty) {
          await removeSpeakerImage(
              speakerId: speaker.id,
              path: speaker.type == 'speaker'
                  ? 'speaker.png'
                  : speaker.type == 'uncle'
                      ? 'uncle.png'
                      : 'aunt.png');
        }
      } else if (speaker is SpeakerCoupleModel) {
        // Remover imagens do tio e da tia se existirem
        if (speaker.uncle.urlImage != null &&
            speaker.uncle.urlImage!.isNotEmpty) {
          await removeSpeakerImage(speakerId: speaker.id, path: 'uncle.png');
        }
        if (speaker.aunt.urlImage != null &&
            speaker.aunt.urlImage!.isNotEmpty) {
          await removeSpeakerImage(speakerId: speaker.id, path: 'aunt.png');
        }
      }

      // Finalmente, deletar o palestrante
      await _speakerService.deleteSpeaker(speakerId: speaker.id);
      getSpeakers();
    } catch (e) {
      debugPrint('Erro ao deletar palestrante: $e');
      throw Exception('Erro ao deletar palestrante: $e');
    }
  }

  // Método para verificar se um palestrante possui palestras associadas
  Future<bool> speakerHasLectures(String speakerId) async {
    try {
      var lectures = await _lectureService.getLecturesBySpeaker(speakerId);
      return lectures.isNotEmpty;
    } catch (e) {
      debugPrint('Erro ao verificar palestras do palestrante: $e');
      throw Exception('Erro ao verificar palestras do palestrante: $e');
    }
  }

  // Método para buscar todas as palestras de um palestrante
  Future<List<LectureModel>> getSpeakerLectures(String speakerId) async {
    try {
      return await _lectureService.getLecturesBySpeaker(speakerId);
    } catch (e) {
      debugPrint('Erro ao buscar palestras do palestrante: $e');
      throw Exception('Erro ao buscar palestras do palestrante: $e');
    }
  }

  Future<Uint8List?> getSpeakerImage(
      {required String speakerId, required String path}) async {
    try {
      return await firebaseStorageService.getImage(
          imagePath: 'speakers/$speakerId/$path');
    } catch (e) {
      throw 'Erro ao retornar imagem: $e';
    }
  }

  Future<String> saveSpeakerImage(
      {required Uint8List image,
      required String speakerId,
      required String path}) async {
    try {
      String? url = await firebaseStorageService.uploadImage(
          image: image, path: 'speakers/$speakerId/$path');
      return url ?? '';
    } catch (e) {
      throw 'Erro ao salvar imagem: $e';
    }
  }

  Future<void> updateImage({required AbstractSpeakerModel speaker}) async {
    try {
      await _speakerService.updateUrlImage(speaker: speaker);
      await getSpeakers();
    } catch (e) {
      throw 'Erro ao atualizar imagem: $e';
    }
  }

  Future<void> removeSpeakerImage({
    required String speakerId,
    required String path,
  }) async {
    try {
      await firebaseStorageService.deleteImage(
          imagePath: 'speakers/$speakerId/$path');
    } catch (e) {
      throw 'Erro ao remover imagem: $e';
    }
  }
}
