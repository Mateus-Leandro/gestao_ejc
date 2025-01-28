import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/answer_model.dart';
import 'package:gestao_ejc/services/answer_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class AnswerController extends ChangeNotifier {
  final AnswerService _answerService = getIt<AnswerService>();

  var _streamController;

  Stream<List<AnswerModel>>? get stream => _streamController.stream;

  void init({required int sequentialEncounter}) {
    _streamController = StreamController<List<AnswerModel>>();
    getAnswers(sequentialEncounter: sequentialEncounter);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> saveAnswer({required AnswerModel answer}) async {
    try {
      await _answerService.saveAnswer(answer: answer);
      getAnswers(sequentialEncounter: answer.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao salvar resposta: $e';
    }
  }

  Future<void> getAnswers({required int sequentialEncounter}) async {
    try {
      var response = await _answerService.getAnswers(
          sequentialEncounter: sequentialEncounter);
      _streamController.sink.add(response);
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
}
