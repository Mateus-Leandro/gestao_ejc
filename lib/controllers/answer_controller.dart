import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/answer_model.dart';
import 'package:gestao_ejc/services/answer_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class AnswerController extends ChangeNotifier {
  final AnswerService _answerService = getIt<AnswerService>();

  var _streamController;

  Stream<List<AnswerModel>>? get stream => _streamController.stream;

  Future<List<AnswerModel>> init({required int sequentialEncounter}) async {
    _streamController = StreamController<List<AnswerModel>>();
    return await getAnswers(sequentialEncounter: sequentialEncounter);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> saveAnswer(
      {required AnswerModel answer, required bool editingAnswer}) async {
    try {
      if (!editingAnswer && await alreadyAnswered(answer: answer)) {
        throw 'Questão ja respondida pelo círculo.';
      }
      await _answerService.saveAnswer(answer: answer);
      getAnswers(sequentialEncounter: answer.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao salvar resposta: $e';
    }
  }

  Future<List<AnswerModel>> getAnswers(
      {required int sequentialEncounter}) async {
    try {
      var response = await _answerService.getAnswers(
          sequentialEncounter: sequentialEncounter);
      _streamController.sink.add(response);
      return response;
    } catch (e) {
      throw 'Erro ao buscar respostas: $e';
    }
  }

  Future<void> deleteAnswer({required AnswerModel answer}) async {
    try {
      await _answerService.deleteAnswer(answer: answer);
      getAnswers(sequentialEncounter: answer.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao deletar resposta: $e';
    }
  }

  Future<bool> alreadyAnswered({required AnswerModel answer}) async {
    try {
      return await _answerService.alreadyAnswered(answer: answer);
    } catch (e) {
      rethrow;
    }
  }
}
