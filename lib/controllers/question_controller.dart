import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/question_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/question_service.dart';

class QuestionController extends ChangeNotifier {
  final QuestionService _questionService = getIt<QuestionService>();

  var _streamController;

  Stream<List<QuestionModel>>? get stream => _streamController.stream;

  void init({required int sequentialEncounter}) {
    _streamController = StreamController<List<QuestionModel>>();
    getQuestions(sequentialEncounter: sequentialEncounter);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> saveQuestion({required QuestionModel question}) async {
    try {
      await _questionService.saveQuestion(question: question);
      getQuestions(sequentialEncounter: question.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao salvar pergunta: $e';
    }
  }

  Future<void> getQuestions({required int sequentialEncounter}) async {
    try {
      var response = await _questionService.getQuestions(
          sequentialEncounter: sequentialEncounter);
      _streamController.sink.add(response);
    } catch (e) {
      throw 'Erro ao buscar perguntas : $e';
    }
  }

  Future<void> deleteQuestion({required QuestionModel question}) async {
    try {
      await _questionService.deleteQuestion(question: question);
      getQuestions(sequentialEncounter: question.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao deletar pergunta: $e';
    }
  }
}
