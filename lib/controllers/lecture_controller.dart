import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/lecture_model.dart';
import 'package:gestao_ejc/models/speaker_model.dart';
import 'package:gestao_ejc/services/lecture_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class LectureController extends ChangeNotifier {
  final LectureService _lectureService = getIt<LectureService>();

  late StreamController<List<LectureModel>> _streamController;
  Stream<List<LectureModel>> get stream => _streamController.stream;

  late int _sequentialEncounter;

  // Cache para armazenar palestrantes já buscados
  final Map<String, AbstractSpeakerModel> _speakersCache = {};

  void init({required int sequentialEncounter}) {
    _sequentialEncounter = sequentialEncounter;
    _streamController = StreamController<List<LectureModel>>();
    getLectures();
  }

  @override
  void dispose() {
    if (!_streamController.isClosed) {
      _streamController.close();
    }
    super.dispose();
  }

  Future<void> getLectures({String? lectureName}) async {
    try {
      final lectures = await _lectureService.getLectures(
        sequentialEncounter: _sequentialEncounter,
        lectureName: lectureName,
      );

      _streamController.sink.add(lectures);
    } catch (e) {
      _streamController.addError('Erro ao listar palestras: $e');
    }
  }

  // Método para buscar palestras por palestrante
  Future<List<LectureModel>> getLecturesBySpeaker(String speakerId) async {
    try {
      return await _lectureService.getLecturesBySpeaker(speakerId);
    } catch (e) {
      debugPrint('Erro ao buscar palestras do palestrante: $e');
      throw Exception('Erro ao buscar palestras do palestrante: $e');
    }
  }

  Future<void> saveLecture({required LectureModel lecture}) async {
    try {
      await _lectureService.saveLecture(lecture: lecture);
      getLectures();
    } catch (e) {
      throw Exception('Erro ao salvar palestra: $e');
    }
  }

  Future<void> deleteLecture({required LectureModel lecture}) async {
    try {
      await _lectureService.deleteLecture(lecture: lecture);
      getLectures();
    } catch (e) {
      throw Exception('Erro ao excluir palestra: $e');
    }
  }

  // Método para remover palestrante de todas as palestras
  Future<void> removeSpeakerFromLectures(String speakerId) async {
    try {
      await _lectureService.removeSpeakerFromLectures(speakerId);
    } catch (e) {
      debugPrint('Erro ao remover palestrante das palestras: $e');
      throw Exception('Erro ao remover palestrante das palestras: $e');
    }
  }

  Future<AbstractSpeakerModel?> getSpeakerById(String speakerId) async {
    // Verificar se já está no cache
    if (_speakersCache.containsKey(speakerId)) {
      return _speakersCache[speakerId];
    }

    try {
      final speaker = await _lectureService.getSpeakerById(speakerId);

      // Adicionar ao cache se encontrado
      if (speaker != null) {
        _speakersCache[speakerId] = speaker;
      }

      return speaker;
    } catch (e) {
      debugPrint('Erro ao buscar palestrante: $e');
      return null;
    }
  }

  Future<Map<DocumentReference, AbstractSpeakerModel>> getSpeakersForLectures(
    List<LectureModel> lectures,
  ) async {
    final Map<DocumentReference, AbstractSpeakerModel> result = {};
    final List<String> idsToFetch = [];
    final Map<String, DocumentReference> refMap = {};

    for (final lecture in lectures) {
      final DocumentReference ref = lecture.referenceSpeaker;
      final String id = ref.id;
      if (!_speakersCache.containsKey(id) && !idsToFetch.contains(id)) {
        idsToFetch.add(id);
        refMap[id] = ref;
      }
    }

    // 2. Busca no backend apenas os novos
    for (final id in idsToFetch) {
      final speaker = await getSpeakerById(id);
      if (speaker != null) {
        final ref = refMap[id]!;
        _speakersCache[id] = speaker;
        result[ref] = speaker;
      }
    }

    for (final lecture in lectures) {
      final DocumentReference ref = lecture.referenceSpeaker;
      final String id = ref.id;
      if (_speakersCache.containsKey(id) && !result.containsKey(ref)) {
        result[ref] = _speakersCache[id]!;
      }
    }

    return result;
  }
}
